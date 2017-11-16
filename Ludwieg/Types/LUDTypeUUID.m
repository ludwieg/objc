//
//  LUDTypeUUID.m
//  Ludwieg
//
//  Created by Victor Gama on 14/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeUUID.h"

@implementation LUDTypeUUID
LUDRepresentsProtocol(LUDProtocolTypeUUID)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    static dispatch_once_t onceToken;
    static NSRegularExpression *regexp;
    dispatch_once(&onceToken, ^{
        regexp = [[NSRegularExpression alloc] initWithPattern:@"^[0-9a-f]{32}$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSString *val = [[[self.value copy] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    if([regexp matchesInString:val options:0 range:NSMakeRange(0, val.length)].count != 1) {
        if(error != nil) {
            *error = [LUDErrorDomain errorWithCode:LUDErrorInvalidUUID];
        }
        return YES;
    }
    const char *str = [val UTF8String];
    uint8_t bytes[16];
    int b = 0;
    char tmpBuf[3] = {'\0', '\0', '\0'};
    unsigned long tmpVal;
    for(int i = 0; i < 32; i += 2) {
        tmpBuf[0] = str[i];
        tmpBuf[1] = str[i+1];

        tmpVal = strtoul(tmpBuf, NULL, 16);
        bytes[b++] = (uint8_t)tmpVal;
    }
    [buf appendBytes:bytes length:16];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    uint8_t buffer[16];
    [buf readLength:16 into:buffer withOffset:offset];
    NSMutableString *val = [[NSMutableString alloc] initWithCapacity:32];
    for(int i = 0; i < 16; i++) {
        [val appendFormat:@"%02x", buffer[i]];
    }
    self.value = [val copy];
    return NO;
}

@end
