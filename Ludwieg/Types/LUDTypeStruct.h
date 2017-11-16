//
//  LUDTypeStruct.h
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDType.h"
#import "LUDSerializable.h"

@interface LUDTypeStruct : LUDType

@property (nonnull, nonatomic, retain) id<LUDSerializable> value;
@property (nonnull, nonatomic, retain) NSArray *deserializedValues;

@end
