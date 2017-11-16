//
//  NSData+Extensions.m
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "NSData+Extensions.h"
#import "LUDOffsetHelper.h"
#import "LUDTypes.h"

@implementation NSData (Extensions)

- (void)readLength:(int)len into:(void *)dst withOffset:(int *)offset {
    [self getBytes:dst range:NSMakeRange(*offset, len)];
    incrementOffsetBy(offset, len);
}

- (uint8_t)readUint8WithOffset:(int *)offset {
    uint8_t size;
    [self readLength:sizeof(uint8_t) into:&size withOffset:offset];
    return size;
}

- (uint16_t)readUint16WithOffset:(int *)offset {
    uint16_t size;
    [self readLength:sizeof(uint16_t) into:&size withOffset:offset];
    return size;
}

- (uint32_t)readUint32WithOffset:(int *)offset {
    uint32_t size;
    [self readLength:sizeof(uint32_t) into:&size withOffset:offset];
    return size;
}

- (uint64_t)readUint64WithOffset:(int *)offset {
    uint64_t size;
    [self readLength:sizeof(uint64_t) into:&size withOffset:offset];
    return size;
}

- (double_t)readFloat64WithOffset:(int *)offset {
    double_t val;
    [self readLength:sizeof(double_t) into:&val withOffset:offset];
    return val;
}

- (uint64_t)readLudwiegSizeWithOffset:(int *)offset {
    LUDLengthEncoding b = [self readUint8WithOffset:offset];

    switch(b) {
        case LUDLengthEncoding8:    return [self readUint8WithOffset:offset];
        case LUDLengthEncoding16:   return [self readUint16WithOffset:offset];
        case LUDLengthEncoding32:   return [self readUint32WithOffset:offset];
        case LUDLengthEncoding64:   return [self readUint64WithOffset:offset];
        default:
            NSAssert(NO, @"Unknown size prefix");
            return 0;
    }
}

- (uint8_t)peekWithOffset:(int *)offset {
    NSRange r = NSMakeRange(*offset, 1);
    uint8_t val;
    [self getBytes:&val range:r];
    return val;
}

@end
