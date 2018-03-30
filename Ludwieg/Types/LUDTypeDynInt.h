//
//  LUDTypeDynInt.h
//  Ludwieg
//
//  Created by Victor Gama on 29/03/2018.
//  Copyright © 2018 Victor Gama. All rights reserved.
//

#import "LUDType.h"

#ifndef __lud_type_dyn_int_kind
#define __lud_type_dyn_int_kind
typedef NS_ENUM(NSUInteger, LUDTypeDynIntKind) {
    LUDTypeDynIntKindInvalid = 0x0,
    LUDTypeDynIntKindUint8   = 0x1,
    LUDTypeDynIntKindUint16  = 0x2,
    LUDTypeDynIntKindUint32  = 0x3,
    LUDTypeDynIntKindUint64  = 0x4,
    LUDTypeDynIntKindInt8    = 0x5,
    LUDTypeDynIntKindInt16   = 0x6,
    LUDTypeDynIntKindInt32   = 0x7,
    LUDTypeDynIntKindInt64   = 0x8,
    LUDTypeDynIntKindFloat32 = 0x9,
    LUDTypeDynIntKindFloat64 = 0xA,
};
#endif

@interface LUDTypeDynInt : LUDType

@property (nonatomic, readonly) LUDTypeDynIntKind underlyingType;
@property (nonatomic, readonly) uint8_t uint8Value;
@property (nonatomic, readonly) uint16_t uint16Value;
@property (nonatomic, readonly) uint32_t uint32Value;
@property (nonatomic, readonly) uint64_t uint64Value;
@property (nonatomic, readonly) int8_t int8Value;
@property (nonatomic, readonly) int16_t int16Value;
@property (nonatomic, readonly) int32_t int32Value;
@property (nonatomic, readonly) int64_t int64Value;
@property (nonatomic, readonly) float_t floatValue;
@property (nonatomic, readonly) double_t doubleValue;
@property (nonatomic, readonly, nullable) NSNumber *numberValue;

+ (nonnull instancetype)dynIntWithUint8:(uint8_t)v;
+ (nonnull instancetype)dynIntWithUint16:(uint16_t)v;
+ (nonnull instancetype)dynIntWithUint32:(uint32_t)v;
+ (nonnull instancetype)dynIntWithUint64:(uint64_t)v;
+ (nonnull instancetype)dynIntWithInt8:(int8_t)v;
+ (nonnull instancetype)dynIntWithInt16:(int16_t)v;
+ (nonnull instancetype)dynIntWithInt32:(int32_t)v;
+ (nonnull instancetype)dynIntWithInt64:(int64_t)v;
+ (nonnull instancetype)dynIntWithFloat32:(float_t)v;
+ (nonnull instancetype)dynIntWithFloat64:(double_t)v;
+ (nonnull instancetype)dynIntWithAny:(double_t)v;
+ (nonnull instancetype)dynIntWithNumber:(nullable NSNumber *)v;

- (void)coerceValue:(double_t)value toKind:(LUDTypeDynIntKind * _Nonnull)outKind andValue:(double_t * _Nonnull)outValue;

@end
