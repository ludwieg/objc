//
//  LUDTypes.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#ifndef LUDTypes_h
#define LUDTypes_h

static const int LUDMagicBytesLength = 3;
static const int8_t LUDMagicBytes[LUDMagicBytesLength] = { 0x27, 0x24, 0x50 };

static const uint8_t LUDHasPrefixedLenghtBit = 0x1;
static const uint8_t LUDIsEmptyBit = 0x2;


/**
 ProtocolType represents a known type that may be transferred using Ludwieg

 - LUDProtocolTypeUnknown: Represents an unknown type, often used as the
 zero-value of a ProtocolType field
 - LUDProtocolTypeUint8: Represents an Uint8 type
 - LUDProtocolTypeUint32: Represents an Uint32 type
 - LUDProtocolTypeUint64: Represents an Uint64 type
 - LUDProtocolTypeDouble: Represents a Float64 type
 - LUDProtocolTypeString: Represents a String type
 - LUDProtocolTypeBlob: Represents a Blob type
 - LUDProtocolTypeBool: Represents a Bool type
 - LUDProtocolTypeArray: Represents an Array type
 - LUDProtocolTypeUUID: Represents am UUID type
 - LUDProtocolTypeAny: Represents any type Ludwieg is capable of handling
 - LUDProtocolTypeStruct: Used internally to identify fields containing
 structs
 */
typedef NS_ENUM(uint8_t, LUDProtocolType) {
    LUDProtocolTypeUnknown = 0x00,
    LUDProtocolTypeUint8 = (0x01 << 2),
    LUDProtocolTypeUint32 = (0x02 << 2),
    LUDProtocolTypeUint64 = (0x03 << 2),
    LUDProtocolTypeDouble = (0x04 << 2),
    LUDProtocolTypeString = (0x05 << 2) | 0x1,
    LUDProtocolTypeBlob = (0x06 << 2) | 0x1,
    LUDProtocolTypeBool = (0x07 << 2),
    LUDProtocolTypeArray = (0x08 << 2) | 0x1,
    LUDProtocolTypeUUID = (0x09 << 2),
    LUDProtocolTypeAny = (0x0A << 2) | 0x1,
    LUDProtocolTypeStruct = (0x0B << 2) | 0x1,
};

static const int LUDKnownTypesLength = 12;

static const uint8_t LUDKnownTypes[LUDKnownTypesLength] = {
    LUDProtocolTypeUnknown, LUDProtocolTypeUint8, LUDProtocolTypeUint32,
    LUDProtocolTypeUint64, LUDProtocolTypeDouble, LUDProtocolTypeString,
    LUDProtocolTypeBlob, LUDProtocolTypeBool, LUDProtocolTypeArray,
    LUDProtocolTypeUUID, LUDProtocolTypeAny, LUDProtocolTypeStruct
};

typedef NS_ENUM(uint8_t, LUDLengthEncoding) {
    LUDLengthEncoding0 = 0x00,
    LUDLengthEncoding8 = 0x01,
    LUDLengthEncoding16 = 0x02,
    LUDLengthEncoding32 = 0x03,
    LUDLengthEncoding64 = 0x04,
};

#endif /* LUDTypes_h */
