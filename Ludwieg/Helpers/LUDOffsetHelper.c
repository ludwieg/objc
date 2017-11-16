//
//  LUDOffsetHelper.c
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#include "LUDOffsetHelper.h"

int incrementOffset(int *offset) {
    return incrementOffsetBy(offset, 1);
}

int incrementOffsetBy(int *offset, int size) {
    int old = *offset;
    *offset = (*offset) + size;
    return old;
}
