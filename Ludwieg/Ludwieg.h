//
//  Ludwieg.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Ludwieg.
FOUNDATION_EXPORT double LudwiegVersionNumber;

//! Project version string for Ludwieg.
FOUNDATION_EXPORT const unsigned char LudwiegVersionString[];

#pragma mark - Protocols
#import <Ludwieg/LUDSerializable.h>
#import <Ludwieg/LUDSerializablePackage.h>

#pragma mark - Types
#import <Ludwieg/LudTypes.h>
#import <Ludwieg/LUDType.h>

#import <Ludwieg/LUDTypeUint8.h>
#import <Ludwieg/LUDTypeUint32.h>
#import <Ludwieg/LUDTypeUint64.h>
#import <Ludwieg/LUDTypeDouble.h>
#import <Ludwieg/LUDTypeBlob.h>
#import <Ludwieg/LUDTypeBool.h>
#import <Ludwieg/LUDTypeString.h>
#import <Ludwieg/LUDTypeUUID.h>
#import <Ludwieg/LUDTypeUnknown.h>
#import <Ludwieg/LUDTypeDynInt.h>

#import <Ludwieg/LUDTypeHelper.h>

#pragma mark - Models
#import <Ludwieg/LUDMessageMeta.h>
#import <Ludwieg/LUDTypeAnnotation.h>
#import <Ludwieg/LUDMetaProtocolByte.h>

#pragma mark - Encoder/Decoder
#import <Ludwieg/LUDSerializer.h>
#import <Ludwieg/LUDDeserializer.h>
