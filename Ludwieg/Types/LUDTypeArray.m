//
//  LUDTypeArray.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeArray.h"
#import "LUDTypeAnnotation.h"

@implementation LUDTypeArray
LUDRepresentsProtocol(LUDProtocolTypeArray)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    NSString *rawArraySize = candidate.annotation.arraySize;
    LUDProtocolType arrayType = candidate.annotation.arrayType;
    if(arrayType == LUDProtocolTypeUnknown) {
        if(error != nil) {
            *error = [LUDErrorDomain errorWithCode:LUDErrorInvalidArrayType];
        }
        return YES;
    }

    if(![rawArraySize isEqualToString:@"*"]) {
        if(atoi([rawArraySize cStringUsingEncoding:[NSString defaultCStringEncoding]]) == 0) {
            if(error != nil) {
                *error = [LUDErrorDomain errorWithCode:LUDErrorInvalidArraySize];
            }
            return YES;
        }
    }

    unsigned long arrayLogicalSize = self.value.count;
    NSMutableData *internalBuffer = [[NSMutableData alloc] init];
    LUDTypeAnnotation *arrayAnnotation = [LUDTypeAnnotation annotationWithName:@"" andType:arrayType];
    LUDMetaProtocolByte *arrayMetaByte = [arrayAnnotation metaProtocolByte];
    for(int i = 0; i < arrayLogicalSize; i++) {
        id itemVal = self.value[i];
        LUDSerializationCandidate *c = [[LUDSerializationCandidate alloc] init];
        c.value = itemVal;
        c.annotation = arrayAnnotation;
        c.meta = arrayMetaByte;
        c.writeType = NO;
        c.isRoot = NO;
        if([LUDType encodeTo:internalBuffer using:c withError:error]) {
            return YES;
        }
    }

    [buf writeLudwiegSize:internalBuffer.length];
    [buf writeUint8:[arrayMetaByte byte]];
    [buf writeLudwiegSize:arrayLogicalSize];
    [buf appendData:internalBuffer];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    const uint64_t payloadSize = [buf readLudwiegSizeWithOffset:offset];
    LUDMetaProtocolByte *metaByte = [LUDMetaProtocolByte metaFromByte:[buf readUint8WithOffset:offset]];
    const uint64_t arraySize = [buf readLudwiegSizeWithOffset:offset];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:arraySize];

    int internalOffset = 0;
    uint8_t payload[payloadSize];
    [buf readLength:(int)payloadSize into:payload withOffset:offset];
    NSData *data = [NSData dataWithBytes:payload length:payloadSize];
    while(internalOffset < payloadSize) {
        LUDType *t = [LUDType decodeWithData:data offset:&internalOffset meta:metaByte andError:error];
        if(*error != nil) {
            return YES;
        }
        id obj = [[self class] coerceInstance:t];
        if(obj == nil) {
            continue;
        }
        [arr addObject:obj];
    }
    self.value = [arr copy];
    return NO;
}

@end
