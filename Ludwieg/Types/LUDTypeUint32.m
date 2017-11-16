//
//  LUDTypeUint32.m
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeUint32.h"

@implementation LUDTypeUint32

LUDRepresentsProtocol(LUDProtocolTypeUint32)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    [buf writeUint32:self.value];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    self.value = [buf readUint32WithOffset:offset];
    return NO;
}

@end
