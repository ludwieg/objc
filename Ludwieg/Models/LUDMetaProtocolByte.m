//
//  LUDMetaProtocolByte.m
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDMetaProtocolByte.h"

@implementation LUDMetaProtocolByte

+ (instancetype)metaFromByte:(uint8_t)byte {
    LUDMetaProtocolByte *instance = [[self alloc] init];
    instance->_isLengthPrefixed = (byte & LUDHasPrefixedLenghtBit) == LUDHasPrefixedLenghtBit;
    instance.isEmpty = (byte & LUDIsEmptyBit) == LUDIsEmptyBit;
    instance.type = (byte &~ LUDIsEmptyBit);
    instance.managedType = LUDProtocolTypeUnknown;
    for(int i = 0; i < LUDKnownTypesLength; i++) {
        LUDProtocolType t = LUDKnownTypes[i];
        if(t == instance.type) {
            instance.managedType = t;
            break;
        }
    }
    return instance;
}

- (BOOL)isKnown {
    return self.managedType != LUDProtocolTypeUnknown;
}

- (uint8_t)byte {
    uint8_t result = self.type;
    if(self.isEmpty) {
        result |= LUDIsEmptyBit;
    } else {
        result &= ~LUDIsEmptyBit;
    }

    if(self.isLengthPrefixed) {
        result |= LUDHasPrefixedLenghtBit;
    } else {
        result &= ~LUDHasPrefixedLenghtBit;
    }

    return result;
}

- (NSString *)description {
    NSMutableString *str = [[NSMutableString alloc] init];
    switch (self.managedType) {
        case LUDProtocolTypeAny:
            [str appendString:@"Any"];
            break;
        case LUDProtocolTypeArray:
            [str appendString:@"Array"];
            break;
        case LUDProtocolTypeBlob:
            [str appendString:@"Blob"];
            break;
        case LUDProtocolTypeBool:
            [str appendString:@"Bool"];
            break;
        case LUDProtocolTypeDouble:
            [str appendString:@"Double"];
            break;
        case LUDProtocolTypeString:
            [str appendString:@"String"];
            break;
        case LUDProtocolTypeStruct:
            [str appendString:@"Struct"];
            break;
        case LUDProtocolTypeUint32:
            [str appendString:@"Uint32"];
            break;
        case LUDProtocolTypeUint64:
            [str appendString:@"Uint64"];
            break;
        case LUDProtocolTypeUint8:
            [str appendString:@"Uint8"];
            break;
        case LUDProtocolTypeUnknown:
            [str appendString:@"Unknown"];
            break;
        case LUDProtocolTypeUUID:
            [str appendString:@"UUID"];
            break;
    }

    if(self->_isLengthPrefixed) {
        [str appendString:@" Length-Prefixed"];
    }

    if(self.isEmpty) {
        [str appendString:@" Empty"];
    }

    return [NSString stringWithFormat:@"<LUDMetaProtocolByte: %@>", str];
}

@end
