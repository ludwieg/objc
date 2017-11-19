//
//  NSMutableData+Extensions.m
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "NSMutableData+Extensions.h"
#import "LUDTypes.h"

@implementation NSMutableData (Extensions)

- (void)writeLudwiegSize:(uint64_t)val {
    if(val == 0) {
        [self writeUint8:LUDLengthEncoding0];
    } else if(val <= UINT8_MAX) {
        [self writeUint8:LUDLengthEncoding8];
        [self writeUint8:val];
    } else if (val <= UINT16_MAX) {
        [self writeUint8:LUDLengthEncoding16];
        [self writeUint16:val];
    } else if (val <= UINT32_MAX) {
        [self writeUint8:LUDLengthEncoding32];
        [self writeUint32:(uint32_t)val];
    } else if (val <= UINT64_MAX) {
        [self writeUint8:LUDLengthEncoding64];
        [self writeUint64:val];
    } else {
        NSAssert(NO, @"Invalid size value %llu", val);
    }
}

- (void)writeUint8:(uint8_t)val {
    [self appendBytes:&val length:sizeof(uint8_t)];
}

- (void)writeUint16:(uint16_t)val {
    [self appendBytes:&val length:sizeof(uint16_t)];
}

- (void)writeUint32:(uint32_t)val {
    uint32_t littleVal = CFSwapInt32HostToLittle(val);
    [self appendBytes:&littleVal length:sizeof(uint32_t)];
}

- (void)writeUint64:(uint64_t)val {
    uint64_t littleVal = CFSwapInt64HostToLittle(val);
    [self appendBytes:&littleVal length:sizeof(uint64_t)];
}

- (void)writeFloat64:(double_t)val {
    typedef union { double_t f; unsigned long long v; } floatBuffer;
    floatBuffer b;
    b.f = val;
    [self appendBytes:&b.v length:sizeof(b.v)];
}

@end
