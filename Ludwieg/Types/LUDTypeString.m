//
//  LUDTypeString.m
//  Ludwieg
//
//  Created by Victor Gama on 13/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeString.h"

@implementation LUDTypeString
LUDRepresentsProtocol(LUDProtocolTypeString)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    NSData *data = [self.value dataUsingEncoding:NSUTF8StringEncoding];
    [buf writeLudwiegSize:data.length];
    [buf appendData:data];
    return NO;

}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    uint64_t size = [buf readLudwiegSizeWithOffset:offset];
    uint8_t buffer[size];
    [buf readLength:(int)size into:buffer withOffset:offset];
    NSData *strData = [NSData dataWithBytes:buffer length:size];
    self.value = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    return NO;
}

@end
