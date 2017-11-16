//
//  NSMutableData+Extensions.h
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (Extensions)

- (void)writeLudwiegSize:(uint64_t)val;
- (void)writeUint8:(uint8_t)val;
- (void)writeUint16:(uint16_t)val;
- (void)writeUint32:(uint32_t)val;
- (void)writeUint64:(uint64_t)val;
- (void)writeFloat64:(double_t)val;

@end
