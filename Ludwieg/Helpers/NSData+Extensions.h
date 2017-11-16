//
//  NSData+Extensions.h
//  Ludwieg
//
//  Created by Victor Gama on 12/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extensions)

- (void)readLength:(int)len into:(nonnull void *)dst withOffset:(nonnull int *)offset;
- (uint64_t)readLudwiegSizeWithOffset:(nonnull int *)offset;
- (uint8_t)readUint8WithOffset:(nonnull int *)offset;
- (uint16_t)readUint16WithOffset:(nonnull int *)offset;
- (uint32_t)readUint32WithOffset:(nonnull int *)offset;
- (uint64_t)readUint64WithOffset:(nonnull int *)offset;
- (double_t)readFloat64WithOffset:(nonnull int *)offset;
- (uint8_t)peekWithOffset:(nonnull int *)offset;

@end
