//
//  LUDMessageMeta.h
//  Ludwieg
//
//  Created by Victor Gama on 11/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 LUDMessageMeta retains basic information about an in or outcoming message, such
 as the protocol version, message ID and type of package being sent.
 */
@interface LUDMessageMeta : NSObject

@property (nonatomic) uint8_t protocolVersion;
@property (nonatomic) uint8_t messageID;
@property (nonatomic) uint8_t packageType;

- (void)writeTo:(NSMutableData *)buf;

@end
