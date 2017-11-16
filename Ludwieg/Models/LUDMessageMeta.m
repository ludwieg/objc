//
//  LUDMessageMeta.m
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDMessageMeta.h"

@implementation LUDMessageMeta

- (void)writeTo:(NSMutableData *)buf {
    uint8_t bytes[3] = {self.protocolVersion, self.messageID, self.packageType};
    [buf appendBytes:bytes length:3];
}

@end
