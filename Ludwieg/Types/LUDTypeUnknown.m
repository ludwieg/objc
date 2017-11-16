//
//  LUDTypeUnknown.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeUnknown.h"

@implementation LUDTypeUnknown
@synthesize value;
LUDRepresentsProtocol(LUDProtocolTypeUnknown)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    if(error != nil) {
        *error = [LUDErrorDomain errorWithCode:LUDErrorCannotEncodeUnknownType];
    }
    return YES;
}


- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    uint64_t size = [buf readLudwiegSizeWithOffset:offset];
    uint8_t tmpBuf[size];
    [buf readLength:(int)size into:tmpBuf withOffset:offset];
    NSData *val = [NSData dataWithBytes:tmpBuf length:size];
    value = val;
    return NO;
}

@end
