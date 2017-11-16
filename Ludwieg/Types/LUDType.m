//
//  LUDType.m
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDType.h"
#import "LUDSerializationCandidate.h"
#import "LUDMetaProtocolByte.h"
#import "LUDTypeSelector.h"
#import "LUDTypeAnnotation.h"
#import "LUDTypeStruct.h"
#import "LUDTypeArray.h"

@implementation LUDType

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    NSAssert(NO, @"Types inheriting LUDType must override encodeValue");
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    NSAssert(NO, @"Types inheriting LUDType must override decodeValue");
    return NO;
}

+ (LUDProtocolType)type {
    NSAssert(NO, @"Do not call LUDType:type directly");
    return LUDProtocolTypeUnknown;
}

+ (BOOL)encodeTo:(NSMutableData *)buf using:(LUDSerializationCandidate *)candidate withError:(NSError *__autoreleasing  _Nonnull *)error {
    if(candidate.writeType) {
        uint8_t byte[1] = {[candidate.meta byte]};
        [buf appendBytes:byte length:1];
    }
    // Here we might coerce and such.
    LUDType *type = candidate.value;
    if(![type isKindOfClass:[LUDType class]] && candidate.annotation.type == LUDProtocolTypeStruct) {
        type = [[LUDTypeStruct alloc] init];
        [type setValue:candidate.value forKey:@"value"];
    } else if([type isKindOfClass:[NSArray class]]) {
        type = [[LUDTypeArray alloc] init];
        [type setValue:candidate.value forKey:@"value"];
    }

    return [type encodeValueTo:buf withCandidate:candidate andError:error];
}

+ (instancetype)decodeWithData:(NSData *)buf offset:(int *)offset meta:(LUDMetaProtocolByte *)meta andError:(NSError *__autoreleasing  _Nonnull *)error {
    Class targetClass = [LUDTypeSelector typeForByte:meta.managedType];
    NSAssert(targetClass != nil, @"LUDTypeSelector should not return nil");
    NSAssert([targetClass isSubclassOfClass:[LUDType class]], @"LUDTypeSelector should return a LUDType-based class");

    __kindof LUDType *result = [[targetClass alloc] init];
    if(meta.isEmpty) {
        result.isEmpty = YES;
        return result;
    }

    result.isEmpty = NO;
    [result decodeValue:buf offset:offset andError:error];
    return result;
}

+ (id)coerceInstance:(LUDType *)inst {
    if(inst == nil) {
        return inst;
    }

    if([inst isKindOfClass:[LUDTypeArray class]]) {
        return ((LUDTypeArray *)inst).value;
    }

    return inst;
}


@end
