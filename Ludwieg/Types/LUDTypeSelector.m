//
//  LUDTypeSelector.m
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDTypeSelector.h"
#import "Types.h"


struct LUDTypeHandler {
    uint8_t identifier;
    Class handler;
};

#define REGISTER_T(index, t) handlers[index].identifier = [t type]; \
                             handlers[index].handler = [t class];

@implementation LUDTypeSelector

+ (nullable Class)typeForByte:(uint8_t)byte {
    static dispatch_once_t onceToken;
    static const int handlersCount = 12;
    static struct LUDTypeHandler handlers[handlersCount];
    dispatch_once(&onceToken, ^{
        REGISTER_T(0, LUDTypeUint8);
        REGISTER_T(1, LUDTypeUint32);
        REGISTER_T(2, LUDTypeUint64);
        REGISTER_T(3, LUDTypeDouble);
        REGISTER_T(4, LUDTypeBlob);
        REGISTER_T(5, LUDTypeBool);
        REGISTER_T(6, LUDTypeString);
        REGISTER_T(7, LUDTypeUUID);
        REGISTER_T(8, LUDTypeUnknown);
        REGISTER_T(9, LUDTypeStruct);
        REGISTER_T(10, LUDTypeArray);
        REGISTER_T(11, LUDTypeAny);
    });
    for(int i = 0; i < handlersCount; i++) {
        if(handlers[i].identifier == byte) {
            return handlers[i].handler;
        }
    }
    return nil;
}

@end
