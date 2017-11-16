//
//  LUDTypeSelector.h
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LUDTypeSelector : NSObject

+ (nullable Class)typeForByte:(uint8_t)byte;

@end
