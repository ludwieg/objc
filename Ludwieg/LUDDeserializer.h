//
//  LUDDeserializer.h
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUDMessageMeta.h"
#import "LUDDeserializationStatistics.h"

@interface LUDDeserializer : NSObject

+ (void)registerPackages:(nonnull Class)klass, ... NS_REQUIRES_NIL_TERMINATION;
+ (nonnull instancetype)deserializer;

- (BOOL)read:(uint8_t)byte intoMessageMeta:(LUDMessageMeta * __nonnull __autoreleasing * __nonnull)meta stats:(LUDDeserializationStatistics * __nonnull __autoreleasing * __nullable)stats andTarget:(id _Nonnull * __nonnull)target;

@end
