//
//  LUDTypeStruct.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeStruct.h"
#import "LUDSerializationCandidate.h"
#import "LUDTypeAnnotation.h"

#import <objc/runtime.h>

@implementation LUDTypeStruct

LUDRepresentsProtocol(LUDProtocolTypeStruct)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    // Technically, the compiler should check it during compilation-time, but
    // still, we need to check it again here, since anything can happen
    // during runtime.
    Class valueClass = [self.value class];
    if(![valueClass conformsToProtocol:@protocol(LUDSerializable)]) {
        if(error != nil) {
            *error = [LUDErrorDomain errorWithCode:LUDErrorNonSerializableType];
        }
        return YES;
    }

    NSArray<LUDTypeAnnotation *> *annotations = [valueClass ludwiegMeta];
    NSMutableData *tmpBuffer = [[NSMutableData alloc] init];

    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(valueClass, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(!propName) {
            continue;
        }
        NSString *propertyName = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
        LUDTypeAnnotation *typeData = [[annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"propertyName = %@", propertyName]] firstObject];
        if(typeData == nil) {
            continue;
        }

        LUDSerializationCandidate *candidate = [[LUDSerializationCandidate alloc] init];

        candidate.value = [self.value performSelector:@selector(valueForKey:) withObject:propertyName];
        candidate.annotation = typeData;
        candidate.meta = [typeData metaProtocolByte];
        candidate.writeType = YES;
        candidate.isRoot = NO;

        NSError *internalError;
        if([LUDType encodeTo:tmpBuffer using:candidate withError:&internalError]) {
            if(error != nil) {
                *error = internalError;
            }
            return YES;
        }
    }

    [buf writeLudwiegSize:tmpBuffer.length];
    [buf appendData:tmpBuffer];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    const uint64_t size = [buf readLudwiegSizeWithOffset:offset];
    uint8_t bytes[size];
    [buf readLength:(int)size into:bytes withOffset:offset];
    NSData *data = [NSData dataWithBytes:bytes length:size];

    int internalOffset = 0;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    while(internalOffset < size) {
        LUDMetaProtocolByte *meta = [LUDMetaProtocolByte metaFromByte:[data readUint8WithOffset:&internalOffset]];
        LUDType *v = [LUDType decodeWithData:data offset:&internalOffset meta:meta andError:error];
        if(*error != nil) {
            return YES;
        }
        id val = [[self class] coerceInstance:v];
        if(val == nil) {
            // Differently from LUDTypeArray, we can't just ditch nil items
            // as everything is index-based. Shifting indexes will make the
            // sky fall over your head.
            val = [NSNull null];
        }
        [arr addObject:val];
    }
    self.deserializedValues = [arr copy];
    return NO;
}

@end
