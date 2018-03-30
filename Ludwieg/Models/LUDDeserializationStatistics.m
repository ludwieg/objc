//
//  LUDDeserializationResult.m
//  Ludwieg
//
//  Created by Victor Gama on 30/03/2018.
//  Copyright © 2018 Victor Gama. All rights reserved.
//

#import "LUDDeserializationStatistics.h"

@implementation LUDDeserializationStatistics {
    uint32_t received;
    uint32_t applied;
}

- (instancetype)initWithReceived:(uint32_t)aReceived andApplied:(uint32_t)anApplied {
    if(self = [super init]) {
        received = aReceived;
        applied = anApplied;
    }
    return self;
}

+ (instancetype)resultWithReceivedFields:(uint32_t)aReceived andApplied:(uint32_t)anApplied {
    return [[self alloc] initWithReceived:aReceived andApplied:anApplied];
}

- (uint32_t)receivedFields { return received; }
- (uint32_t)appliedFields { return applied; }
- (BOOL)knowsAllFields { return received == applied; }

@end
