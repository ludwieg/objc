//
//  LUDMetaProtocolByte.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUDTypes.h"

@interface LUDMetaProtocolByte : NSObject

@property (nonatomic) uint8_t type;
@property (nonatomic) LUDProtocolType managedType;
@property (nonatomic) BOOL isEmpty;
@property (nonatomic, readonly) BOOL isLengthPrefixed;
@property (nonatomic, readonly) BOOL isKnown;

+ (nonnull instancetype)metaFromByte:(uint8_t)byte;
- (uint8_t)byte;

@end
