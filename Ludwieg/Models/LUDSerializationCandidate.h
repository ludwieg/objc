//
//  LUDSerializationCandidate.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LUDType, LUDTypeAnnotation, LUDMetaProtocolByte;


/**
 LUDSerializationCandidate is used internally by the serialiser to retain
 metadata about a value being serialised.
 */
@interface LUDSerializationCandidate : NSObject


/**
 Retains the reflected value of the entity being serialised
 */
@property (nonatomic, retain, nullable) LUDType *value;

/**
 Retains information recovered through the @c{LudType#ludwiegMeta} defined by
 the structure holding the value being serialised
 */
@property (nonatomic, retain, nonnull) LUDTypeAnnotation *annotation;


/**
  Retains information about the type being serialised
 */
@property (nonatomic, retain, nonnull) LUDMetaProtocolByte *meta;


/**
 Indicates whether the serialiser must write information about the type when
 writing this entity to the buffer. Operations such as array serialisation set
 this field as false, in order to avoid overhead
 */
@property (nonatomic) BOOL writeType;


/**
 Only used by the struct serialiser, since it is shared among other generic
 serializers
 */
@property (nonatomic) BOOL isRoot;

@end
