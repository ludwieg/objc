//
//  LUDTypeUint8.m
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeUint8.h"

@implementation LUDTypeUint8

LUDRepresentsProtocol(LUDProtocolTypeUint8)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    [buf writeUint8:self.value];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    self.value = [buf readUint8WithOffset:offset];
    return NO;
}

@end
