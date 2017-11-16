//
//  LUDSerializable.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LUDTypeAnnotation;

@protocol LUDSerializable <NSObject>

+ (NSArray<LUDTypeAnnotation *> *)ludwiegMeta;

@end
