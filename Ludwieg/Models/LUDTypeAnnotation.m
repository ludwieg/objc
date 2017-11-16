//
//  LUDTypeAnnotation.m
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeAnnotation.h"
#import "LUDMetaProtocolByte.h"

@implementation LUDTypeAnnotation

+ (instancetype)annotationWithName:(NSString *)name andType:(LUDProtocolType)type {
    LUDTypeAnnotation *instance = [[LUDTypeAnnotation alloc] init];
    instance.type = type;
    instance.propertyName = name;
    return instance;
}

+ (instancetype)arrayAnnotationWithName:(NSString *)name type:(LUDProtocolType)type andArraySize:(NSString *)arraySize {
    LUDTypeAnnotation *instance = [self annotationWithName:name andType:LUDProtocolTypeArray];
    instance.arrayType = type;
    instance.arraySize = arraySize;
    return instance;
}

+ (instancetype)arrayAnnotationWithName:(NSString *)name userType:(Class)klass andArraySize:(NSString *)arraySize {
    LUDTypeAnnotation *instance = [self arrayAnnotationWithName:name type:LUDProtocolTypeStruct andArraySize:arraySize];
    instance.userType = klass;
    return instance;
}

- (LUDMetaProtocolByte *)metaProtocolByte {
    return [LUDMetaProtocolByte metaFromByte:self.type];
}

@end
