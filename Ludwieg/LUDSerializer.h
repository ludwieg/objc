//
//  LUDSerializer.h
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUDSerializablePackage.h"

@interface LUDSerializer : NSObject

+ (nonnull NSData *)serializePackage:(nonnull id<LUDSerializablePackage>)pkg withMessageID:(uint8_t)msgID andError:(NSError * __nonnull __autoreleasing * __nonnull)error;

@end
