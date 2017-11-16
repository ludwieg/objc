//
//  LUDTypeHelper.hpp
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#ifndef LUDTypeHelper_h
#define LUDTypeHelper_h

#import <Foundation/Foundation.h>
#import "Types.h"

#define MakeShorthand(native_type, lud_type, name) NS_INLINE lud_type *name(native_type v) { \
    lud_type *ret = [[lud_type alloc] init]; \
    ret.isEmpty = NO; \
    ret.value = v; \
    return ret; \
}

MakeShorthand(uint8_t, LUDTypeUint8, LUDUint8);
MakeShorthand(uint32_t, LUDTypeUint32, LUDUint32);
MakeShorthand(uint64_t, LUDTypeUint64, LUDUint64);
MakeShorthand(double_t, LUDTypeFloat64, LUDFloat64);
MakeShorthand(NSData *, LUDTypeBlob, LUDBlob);
MakeShorthand(BOOL, LUDTypeBool, LUDBool);
MakeShorthand(NSString *, LUDTypeString, LUDString);
MakeShorthand(NSString *, LUDTypeUUID, LUDUUID);
MakeShorthand(id, LUDTypeAny, LUDAny);

#endif /* LUDTypeHelper_h */
