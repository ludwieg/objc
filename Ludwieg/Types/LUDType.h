//
//  LUDType.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUDTypes.h"
#import "LUDOffsetHelper.h"
#import "NSData+Extensions.h"
#import "NSMutableData+Extensions.h"
#import "LUDErrorDomain.h"
#import "LUDSerializationCandidate.h"
#import "LUDMetaProtocolByte.h"

#define LUDBuf(size) uint8_t bytes[size]; [buf readLength:size into:bytes withOffset:offset];
#define LUDRepresentsProtocol(t) + (LUDProtocolType)type { return t; }
#define LUDShortcut(native, t) 

@interface LUDType : NSObject

@property (nonatomic) BOOL isEmpty;

- (BOOL)encodeValueTo:(nonnull NSMutableData *)buf withCandidate:(nonnull LUDSerializationCandidate *)candidate andError:(NSError * __nonnull __autoreleasing * __nonnull)error;
- (BOOL)decodeValue:(nonnull NSData *)buf offset:(nonnull int *)offset andError:(NSError * __nonnull __autoreleasing * __nonnull)error;
+ (LUDProtocolType)type;

+ (nullable instancetype)decodeWithData:(nonnull NSData *)buf offset:(nonnull int *)offset meta:(nonnull LUDMetaProtocolByte *)meta andError:(NSError * __nonnull __autoreleasing * __nonnull)error;
+ (BOOL)encodeTo:(nonnull NSMutableData *)buf using:(nonnull LUDSerializationCandidate *)candidate withError:(NSError * __nonnull __autoreleasing * __nonnull)error;
+ (nullable id)coerceInstance:(nullable LUDType *)inst;
@end
