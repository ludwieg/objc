//
//  LUDTypeDouble.m
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeDouble.h"

@implementation LUDTypeDouble
LUDRepresentsProtocol(LUDProtocolTypeDouble)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    [buf writeFloat64:self.value];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    self.value = [buf readFloat64WithOffset:offset];
    return NO;
}

@end
