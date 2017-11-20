//
//  LUDTypeAny.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "Types.h"
#import "LUDSerializationCandidate.h"
#import "LUDTypeAnnotation.h"

@implementation LUDTypeAny
LUDRepresentsProtocol(LUDProtocolTypeAny)

- (BOOL)encodeValueTo:(NSMutableData *)buf withCandidate:(LUDSerializationCandidate *)candidate andError:(NSError *__autoreleasing  _Nonnull *)error {
    NSMutableData *internalBuffer = [[NSMutableData alloc] init];
    if([self.value isKindOfClass:[LUDType class]]) {
        LUDType *val = self.value;
        LUDSerializationCandidate *c = [[LUDSerializationCandidate alloc] init];
        LUDProtocolType t = [[val class] type];
        c.value = val;
        c.annotation = [LUDTypeAnnotation annotationWithName:@"" andType:t];
        c.meta = [LUDMetaProtocolByte metaFromByte:t];
        c.writeType = YES;

        if([LUDType encodeTo:internalBuffer using:c withError:error]) {
            return YES;
        }
    } else if([self.value isKindOfClass:[NSArray class]]) {
        LUDProtocolType arrayType = [self detectObjectTypeInArray:self.value];
        if(arrayType == LUDProtocolTypeUnknown) {
            if(error != nil) {
                *error = [LUDErrorDomain errorWithCode:LUDErrorCannotEncodeUnknownType];
            }
            return YES;
        }
        NSArray *val = self.value;
        LUDSerializationCandidate *c = [[LUDSerializationCandidate alloc] init];
        LUDProtocolType t = LUDProtocolTypeArray;
        c.value = [[LUDTypeArray alloc] init];
        [c.value setValue:val forKey:@"value"];
        c.annotation = [LUDTypeAnnotation arrayAnnotationWithName:@"" type:arrayType andArraySize:@"*"];
        c.meta = [LUDMetaProtocolByte metaFromByte:t];
        c.writeType = YES;

        if([LUDType encodeTo:internalBuffer using:c withError:error]) {
            return YES;
        }
    } else {
        if(error != nil) {
            *error = [LUDErrorDomain errorWithCode:LUDErrorInvalidTypeForAny];
        }
        return YES;
    }

    [buf writeLudwiegSize:internalBuffer.length];
    [buf appendData:internalBuffer];
    return NO;
}

- (BOOL)decodeValue:(NSData *)buf offset:(int *)offset andError:(NSError *__autoreleasing  _Nonnull *)error {
    uint64_t payloadSize = [buf readLudwiegSizeWithOffset:offset];
    uint8_t tmpBytes[payloadSize];
    [buf readLength:(int)payloadSize into:tmpBytes withOffset:offset];

    NSData *tmpBuf = [[NSData alloc] initWithBytes:tmpBytes length:payloadSize];
    int internalOffset = 0;
    LUDMetaProtocolByte *meta = [LUDMetaProtocolByte metaFromByte:[tmpBuf readUint8WithOffset:&internalOffset]];
    LUDType *result = [LUDType decodeWithData:tmpBuf offset:&internalOffset meta:meta andError:error];
    if(*error != nil) {
        return YES;
    }
    self.value = [[self class] coerceInstance:result];
    return NO;
}

- (LUDProtocolType)detectObjectTypeInArray:(NSArray *)arr {
    if(arr.count == 0) {
        // At this point, we have a big problem, since we can't infer type
        // from an empty array, and objc's type erasure makes it unable to
        // collect generic information.
        // So here we will just return an TypeUnknown that will probably
        // crash the upstream caller.
        return LUDProtocolTypeUnknown;
    }

    id type = arr[0];

    if([type isKindOfClass:[LUDTypeUint8 class]]) {
        return [LUDTypeUint8 type];
    } else if([type isKindOfClass:[LUDTypeUint32 class]]) {
        return [LUDTypeUint32 type];
    } else if([type isKindOfClass:[LUDTypeUint64 class]]) {
        return [LUDTypeUint64 type];
    } else if([type isKindOfClass:[LUDTypeDouble class]]) {
        return [LUDTypeDouble type];
    } else if([type isKindOfClass:[LUDTypeBlob class]]) {
        return [LUDTypeBlob type];
    } else if([type isKindOfClass:[LUDTypeBool class]]) {
        return [LUDTypeBool type];
    } else if([type isKindOfClass:[LUDTypeString class]]) {
        return [LUDTypeString type];
    } else if([type isKindOfClass:[LUDTypeUUID class]]) {
        return [LUDTypeUUID type];
    } else if([type isKindOfClass:[LUDTypeUnknown class]]) {
        return [LUDTypeUnknown type];
    } else if([type isKindOfClass:[LUDTypeArray class]]) {
        return [LUDTypeArray type];
    }


    // As a last restort, return TypeUnknown. This will make the upstream
    // caller to halt.
    return LUDProtocolTypeUnknown;

}
@end
