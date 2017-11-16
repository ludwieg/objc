//
//  LUDSerializer.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDSerializer.h"
#import "LUDTypes.h"
#import "Types.h"
#import "LUDMessageMeta.h"
#import "LUDSerializationCandidate.h"

@implementation LUDSerializer

+ (NSData *)serializePackage:(id<LUDSerializablePackage>)pkg withMessageID:(uint8_t)msgID andError:(NSError *__autoreleasing  _Nonnull *)error {
    NSMutableData *data = [[NSMutableData alloc] init];

    [data appendBytes:LUDMagicBytes length:LUDMagicBytesLength];

    LUDMessageMeta *meta = [[LUDMessageMeta alloc] init];
    meta.protocolVersion = 0x01;
    meta.messageID = msgID;
    meta.packageType = [[pkg class] ludwiegID];
    [meta writeTo:data];

    LUDSerializationCandidate *candidate = [[LUDSerializationCandidate alloc] init];
    LUDTypeStruct *str = [[LUDTypeStruct alloc] init];
    str.value = pkg;
    candidate.value = str;
    candidate.isRoot = YES;
    candidate.writeType = NO;
    [LUDType encodeTo:data using:candidate withError:error];

    return data;
}

@end
