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
    LUDType *type = candidate.value;
    BOOL isEmpty = type == nil || ([type isKindOfClass:[NSArray class]] && ((NSArray *)type).count == 0);

    if(candidate.writeType) {
        candidate.meta.isEmpty = isEmpty;
        [buf writeUint8:[candidate.meta byte]];
    }

    if(isEmpty) {
        return NO;
    }

    // Here we might coerce and such.

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
