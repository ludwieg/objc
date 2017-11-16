//
//  LUDTypeBool.m
//  Ludwieg
//
//  Created by Victor Gama on 13/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeBool.h"

@implementation LUDTypeBool
LUDRepresentsProtocol(LUDProtocolTypeBool)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    [buf writeUint8:self.value ? 0x01 : 0x00];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    uint8_t v = [buf readUint8WithOffset:offset];
    self.value = v == 0x01;
    return NO;
}

@end
