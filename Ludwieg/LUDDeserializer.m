//
//  LUDDeserializer.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDDeserializer.h"
#import "LUDTypes.h"
#import "LUDType.h"
#import "LUDMetaProtocolByte.h"
#import "LUDTypeAnnotation.h"
#import "LUDTypeSelector.h"
#import "LUDSerializable.h"
#import "LUDSerializablePackage.h"
#import "Types.h"

#import "NSData+Extensions.h"
#import "NSMutableData+Extensions.h"

#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, deserializerStatus) {
    deserializerStatusPrelude,
    deserializerStatusVersion,
    deserializerStatusMessageID,
    deserializerStatusPackageType,
    deserializerStatusPackageSizePrelude,
    deserializerStatusPackageSizeValue,
    deserializerStatusPayload,
};

@implementation LUDDeserializer {
    deserializerStatus state;
    NSMutableData *tmpBuffer;
    uint64_t readBytes;
    uint8_t messageSizeBytes;
    uint64_t packageSize;
    uint8_t rawPackageType;
}
#pragma mark - Registry

typedef struct {
    Class   klass;
    uint8_t identifier;
} RegisteredPackage;

typedef struct {
    RegisteredPackage *array;
    size_t              used;
    size_t              size;
} PackageRegistry;


static PackageRegistry registry;
static BOOL registryReady;

static void allocRegistry() {
    if(!registryReady) {
        registry.array = malloc(3 * sizeof(RegisteredPackage));
        registry.used = 0;
        registry.size = 3;
        registryReady = YES;
    }
}

static void registerPackage(RegisteredPackage v) {
    if(registry.used == registry.size) {
        registry.size *= 2;
        registry.array = realloc(registry.array, registry.size * sizeof(RegisteredPackage));
    }
    registry.array[registry.used++] = v;
}

static BOOL lookupPackage(uint8_t identifier, RegisteredPackage *p) {
    for(int i = 0; i < registry.used; i++) {
        if(registry.array[i].identifier == identifier) {
            *p = registry.array[i];
            return YES;
        }
    }
    return NO;
}

+ (void)registerPackages:(Class)firstClass, ... {
    allocRegistry();
    va_list args;
    va_start(args, firstClass);
    Class klass = firstClass;
    do {
        RegisteredPackage pkg = {klass, [((id<LUDSerializablePackage>)klass) ludwiegID]};
        registerPackage(pkg);
    } while((klass = va_arg(args,id)));
    va_end(args);
}

+ (instancetype)deserializer {
    LUDDeserializer *inst = [[self alloc] init];
    inst->tmpBuffer = [[NSMutableData alloc] init];
    [inst reset];
    return inst;
}

- (void)reset {
    self->state = deserializerStatusPrelude;
    [self->tmpBuffer setLength:0];
    self->readBytes = 0;
}

- (BOOL)read:(uint8_t)byte intoMessageMeta:(LUDMessageMeta *__autoreleasing  __nullable *)meta andTarget:(id  _Nullable __autoreleasing *)target {
    if(meta != nil && (*meta) == nil) {
        *meta = [[LUDMessageMeta alloc] init];
    }

    switch (self->state) {
        case deserializerStatusPrelude: {
            uint8_t expectedByte = LUDMagicBytes[readBytes];
            if(byte == expectedByte) {
                self->readBytes++;
                if(self->readBytes == LUDMagicBytesLength) {
                    self->state = deserializerStatusVersion;
                }
            } else {
                [self reset];
            }
            break;
        }
        case deserializerStatusVersion: {
            if(meta != nil) {
                (*meta).protocolVersion = byte;
            }
            self->readBytes++;
            self->state = deserializerStatusMessageID;
            break;
        }
        case deserializerStatusMessageID: {
            if(meta != nil) {
                (*meta).messageID = byte;
            }
            self->readBytes++;
            self->state = deserializerStatusPackageType;
            break;
        }
        case deserializerStatusPackageType: {
            if(meta != nil) {
                (*meta).packageType = byte;
            }
            rawPackageType = byte;
            self->readBytes++;
            self->state = deserializerStatusPackageSizePrelude;
            break;
        }
        case deserializerStatusPackageSizePrelude: {
            if(byte < LUDLengthEncoding8 || byte > LUDLengthEncoding64) {
                [self reset];
                break;
            }
            switch ((LUDLengthEncoding)byte) {
                case LUDLengthEncoding8:
                    self->messageSizeBytes = 1;
                    break;
                case LUDLengthEncoding16:
                    self->messageSizeBytes = 2;
                    break;
                case LUDLengthEncoding32:
                    self->messageSizeBytes = 4;
                    break;
                case LUDLengthEncoding64:
                    self->messageSizeBytes = 8;
                    break;
            }
            [tmpBuffer setLength:0];
            readBytes++;
            self->state = deserializerStatusPackageSizeValue;
            break;
        }
        case deserializerStatusPackageSizeValue: {
            [tmpBuffer writeUint8:byte];
            self->readBytes++;
            if(tmpBuffer.length == self->messageSizeBytes) {
                int dummy = 0;
                switch(self->messageSizeBytes) {
                    case 1:
                        self->packageSize = [tmpBuffer readUint8WithOffset:&dummy];
                        break;
                    case 2:
                        self->packageSize = [tmpBuffer readUint16WithOffset:&dummy];
                        break;
                    case 3:
                        self->packageSize = [tmpBuffer readUint32WithOffset:&dummy];
                        break;
                    case 4:
                        self->packageSize = [tmpBuffer readUint64WithOffset:&dummy];
                        break;
                }
            }
            [tmpBuffer setLength:0];
            self->state = deserializerStatusPayload;
            break;
        }
        case deserializerStatusPayload: {
            [tmpBuffer writeUint8:byte];
            readBytes++;
            if(tmpBuffer.length == self->packageSize) {
                return [self handleDeserializationWithTarget:target];
            }
        }
    }
    return NO;
}

- (BOOL)handleDeserializationWithTarget:(id  _Nullable __autoreleasing *)target {
    RegisteredPackage p;
    if(!lookupPackage(rawPackageType, &p)) {
        [self reset];
        return NO;
    }
    if ([self deserializeInto:target usingClass:p.klass]) {
        return NO;
    }
    [self reset];
    return YES;
}

- (BOOL)deserializeInto:(id __nullable __autoreleasing *)target usingClass:(Class)klass {
    int offset = 0;
    const uint64_t size = tmpBuffer.length;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    while(offset < size) {
        LUDMetaProtocolByte *meta = [LUDMetaProtocolByte metaFromByte:[tmpBuffer readUint8WithOffset:&offset]];
        NSError *error = nil;
        __kindof LUDType *item = [LUDType decodeWithData:tmpBuffer offset:&offset meta:meta andError:&error];
        if(error != nil) {
            NSLog(@"[LUDDeserializer] Error deserialising: %@", error);
            return NO;
        }
        [items addObject:item];
    }

    // At this point, everything is fine. Yay.
    // Now comes the hard-ish part: Place all values into correct places.
    *target = [self fillClass:klass usingValues:items];
    return NO;
}


- (id)fillClass:(Class)cls usingValues:(NSArray *)arr {
    NSArray<LUDTypeAnnotation *> *annotations = [cls ludwiegMeta];
    unsigned int propCount;
    objc_property_t *properties = class_copyPropertyList(cls, &propCount);
    id instance = [[cls alloc] init];

    for(int i = 0; i < annotations.count; i++) {
        if(i >= propCount) break; // There's nothing else we can do here.
        if(i >= arr.count) break;
        id value = [arr objectAtIndex:i];
        LUDTypeAnnotation *annotation = annotations[i];
        if(value == nil || [value isEqual:[NSNull null]]) {
            continue;
        }
        const char *pRawName = property_getName(properties[i]);
        NSString *propName = [NSString stringWithUTF8String:pRawName];

        if([value isKindOfClass:[LUDTypeStruct class]]) {
            // Oh. This is a struct.
            // We "just" need to determine its type and make a recursive call
            // to this same method.
            NSString *propType = [[[NSString stringWithUTF8String:property_getAttributes(properties[i])] componentsSeparatedByString:@","] firstObject];
            if(![propType hasPrefix:@"T@"]) {
                // Okay, I don't know what else can be done here.
                continue;
            }
            NSString * typeClassName = [propType substringWithRange:NSMakeRange(3, [propType length]-4)];
            Class typeClass = NSClassFromString(typeClassName);
            if(typeClass == nil) {
                NSLog(@"[LUDDeserializer] Cannot recover class with name %@", typeClass);
                continue;
            }
            value = [self fillClass:typeClass usingValues:((LUDTypeStruct *)value).deserializedValues];
        } else if([value isKindOfClass:[LUDTypeArray class]]) {
            if(annotation.arrayType == LUDProtocolTypeStruct) {
                // Here we want to pay extra attention to the array, since
                // the target type is another class, and not LUDTypeStruct
                Class targetClass = annotation.userType;
                LUDTypeArray *currentArray = (LUDTypeArray *)value;
                NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:currentArray.value.count];
                for(LUDTypeStruct *s in currentArray.value) {
                    [newArray addObject:[self fillClass:targetClass usingValues:s.deserializedValues]];
                }
                value = newArray;
            } else {
                value = ((LUDTypeArray *)value).value;
            }
        }

        [instance setValue:value forKey:propName];
    }
    return instance;
}


@end
