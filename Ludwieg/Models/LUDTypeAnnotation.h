//
//  LUDTypeAnnotation.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LUDTypes.h"

@class LUDMetaProtocolByte;

/**
 LudwiegTypeAnnotation is used to annotate interface types based on indexed
 fields.
 */
@interface LUDTypeAnnotation : NSObject

@property (nonatomic, nonnull, retain) NSString *propertyName;
@property (nonatomic) LUDProtocolType type;
@property (nonatomic) LUDProtocolType arrayType;
@property (nonatomic, nullable, retain) NSString *arraySize;
@property (nonatomic, nullable, retain) Class userType;

+ (nonnull instancetype)annotationWithName:(nonnull NSString *)name andType:(LUDProtocolType)type;
+ (nonnull instancetype)arrayAnnotationWithName:(nonnull NSString *)name type:(LUDProtocolType)type andArraySize:(nonnull NSString *)arraySize;
+ (nonnull instancetype)arrayAnnotationWithName:(nonnull NSString *)name userType:(nonnull Class)klass andArraySize:(nonnull NSString *)arraySize;

- (nonnull LUDMetaProtocolByte *)metaProtocolByte;
@end
