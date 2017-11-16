//
//  LUDSerializablePackage.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUDSerializable.h"

@protocol LUDSerializablePackage <LUDSerializable>

+ (uint8_t)ludwiegID;

@end
