//
//  LUDTypeBlob.m
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeBlob.h"

@implementation LUDTypeBlob
LUDRepresentsProtocol(LUDProtocolTypeBlob)


- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    [buf writeLudwiegSize:self.value.length];
    [buf appendData:self.value];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    uint64_t size = [buf readLudwiegSizeWithOffset:offset];
    uint8_t intBuf[size];
    [buf readLength:(int)size into:intBuf withOffset:offset];
    self.value = [NSData dataWithBytes:intBuf length:size];
    return NO;
}
@end
