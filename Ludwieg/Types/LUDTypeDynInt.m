//
//  LUDTypeDynInt.m
//  Ludwieg
//
//  Created by Victor Gama on 29/03/2018.
//  Copyright © 2018 Victor Gama. All rights reserved.
//

#import "LUDTypeDynInt.h"
#import <float.h>

@implementation LUDTypeDynInt {
    double value;
    LUDTypeDynIntKind kind;
    NSNumber *cachedNumber;
}

LUDRepresentsProtocol(LUDProtocolTypeDynInt)

static const double EPSILON = 1e-9;

- (void)coerceValue:(double_t)value toKind:(LUDTypeDynIntKind *)outKind andValue:(double_t *)outValue {
    // First, check for fractional part of value and determine whether we're
    // handling a float or integer value.
    double_t frac = fmod(value, 1);
    double_t integer = value - frac;
    if(frac > EPSILON && frac < 1.0 - EPSILON) {
        // Handling a float. Now determine whether it's a 32 or 64-bit float
        if(value > FLT_MIN  && value <= FLT_MAX) {
            *outKind = LUDTypeDynIntKindFloat32;
            *outValue = value;
            return;
        }
    }

    double maxMins[9][2] = {
        {0, UINT8_MAX},
        {0, UINT16_MAX},
        {0, UINT32_MAX},
        {0, UINT64_MAX},
        {INT8_MIN, INT8_MAX},
        {INT16_MIN, INT16_MAX},
        {INT32_MIN, INT32_MAX},
        {INT64_MIN, INT64_MAX},
    };

    LUDTypeDynIntKind types[9] = {
        LUDTypeDynIntKindUint8,
        LUDTypeDynIntKindUint16,
        LUDTypeDynIntKindUint32,
        LUDTypeDynIntKindUint64,
        LUDTypeDynIntKindInt8,
        LUDTypeDynIntKindInt16,
        LUDTypeDynIntKindInt32,
        LUDTypeDynIntKindInt64,
    };

    for(int i = 0; i < 9; i++) {
        if(integer >= maxMins[i][0] && integer <= maxMins[i][1]) {
            *outKind = types[i];
            *outValue = integer;
            return;
        }
    }

    *outKind = LUDTypeDynIntKindInvalid;
    *outValue = 0;
}

- (instancetype)initWithValue:(double_t)aValue {
    if(self = [super init]) {
        [self coerceValue:aValue toKind:&kind andValue:&value];
        self.isEmpty = false;
    }

    return self;
}

- (instancetype)initEmpty {
    if(self = [super init]) {
        self.isEmpty = true;
    }

    return self;
}

- (LUDTypeDynIntKind)underlyingType { return kind; }

- (uint8_t)uint8Value { return value; }
- (uint16_t)uint16Value { return value; }
- (uint32_t)uint32Value { return value; }
- (uint64_t)uint64Value { return value; }
- (int8_t)int8Value { return value; }
- (int16_t)int16Value { return value; }
- (int32_t)int32Value { return value; }
- (int64_t)int64Value { return value; }
- (float_t)floatValue { return value; }
- (double_t)doubleValue { return value; }
- (NSNumber *)numberValue {
    if(!self.isEmpty) {
        return nil;
    }

    if(cachedNumber == nil) {
        cachedNumber = [NSNumber numberWithDouble:value];
    }
    return cachedNumber;
}

+ (instancetype)dynIntWithUint8:(uint8_t)v      { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithUint16:(uint16_t)v    { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithUint32:(uint32_t)v    { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithUint64:(uint64_t)v    { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithInt8:(int8_t)v        { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithInt16:(int16_t)v      { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithInt32:(int32_t)v      { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithInt64:(int64_t)v      { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithFloat32:(float_t)v    { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithAny:(double_t)v       { return [self dynIntWithFloat64:v]; }
+ (instancetype)dynIntWithFloat64:(double_t)v   {
    return [[self alloc] initWithValue:v];
}

+ (instancetype)dynIntWithNumber:(NSNumber *)v {
    if(v == nil) {
        return [[self alloc] initEmpty];
    }

    return [[self alloc] initWithValue:v.doubleValue];
}



- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    [buf writeUint8:kind];
    switch (kind) {
        case LUDTypeDynIntKindInvalid:
            *error = [LUDErrorDomain errorWithCode:LudErrorCannotEncodeInvalidDynInt];
            return YES;
        case LUDTypeDynIntKindUint8:
        case LUDTypeDynIntKindInt8:
            [buf writeUint8:(uint8_t)value];
            break;
        case LUDTypeDynIntKindUint16:
        case LUDTypeDynIntKindInt16:
            [buf writeUint16:(uint16_t)value];
            break;
        case LUDTypeDynIntKindUint32:
        case LUDTypeDynIntKindInt32:
            [buf writeUint32:(uint32_t)value];
            break;
        case LUDTypeDynIntKindUint64:
        case LUDTypeDynIntKindInt64:
            [buf writeUint64:(uint64_t)value];
            break;
        case LUDTypeDynIntKindFloat32:
        case LUDTypeDynIntKindFloat64:
            [buf writeFloat64:value];
            break;
    }
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    kind = [buf readUint8WithOffset:offset];
    switch (kind) {
        case LUDTypeDynIntKindUint8:
        case LUDTypeDynIntKindInt8:
            value = [buf readUint8WithOffset:offset];
            break;
        case LUDTypeDynIntKindUint16:
        case LUDTypeDynIntKindInt16:
            value = [buf readUint16WithOffset:offset];
            break;
        case LUDTypeDynIntKindUint32:
        case LUDTypeDynIntKindInt32:
            value = [buf readUint32WithOffset:offset];
            break;
        case LUDTypeDynIntKindUint64:
        case LUDTypeDynIntKindInt64:
            value = [buf readUint64WithOffset:offset];
            break;
        case LUDTypeDynIntKindFloat32:
        case LUDTypeDynIntKindFloat64:
            value = [buf readFloat64WithOffset:offset];
            break;
        default:
            return NO;
    }
    return NO;
}

@end
