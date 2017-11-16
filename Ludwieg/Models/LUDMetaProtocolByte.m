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

@end
