//
//  LUDErrorDomain.h
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LUDError enumerates all errors defined in the Ludwieg error domain

 - LUDErrorInvalidUUID: Indicates that the provided UUID is invalid
 - LUDErrorCannotEncodeUnknownType: Indicates that there was an illegal
 attempt of serializing an unknown type.
 - LUDErrorNonSerializableType: Indicates that there was an illegal attempt
 of serializing an non-serializable type. Serializable types must conform
 to `LUDSerializable`, whilst packages must conform to
 `LUDSerializablePackage`.
 */
typedef NS_ENUM(NSUInteger, LUDError) {
    LUDErrorInvalidUUID = 10,
    LUDErrorCannotEncodeUnknownType = 20,
    LUDErrorNonSerializableType = 30,
    LUDErrorInvalidArrayType = 40,
    LUDErrorInvalidArraySize = 50,
    LUDErrorInvalidTypeForAny = 60,
};

@interface LUDErrorDomain : NSObject

+ (nonnull NSString *)errorDomain;
+ (nonnull NSError *)errorWithCode:(LUDError)error;

@end
