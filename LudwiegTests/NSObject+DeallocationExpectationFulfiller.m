//
//  NSObject+DeallocationExpectationFulfiller.m
//  LudwiegTests
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "NSObject+DeallocationExpectationFulfiller.h"
#import "DeallocationExpectationFulfiller.h"
#import <objc/runtime.h>

@implementation NSObject (DeallocationExpectationFulfiller)

static const void *fullfillerKey = &fullfillerKey;

- (DeallocationExpectationFulfiller *)deallocFulfiller {
    return objc_getAssociatedObject(self, fullfillerKey);
}

- (void)setDeallocFulfiller:(DeallocationExpectationFulfiller *)deallocFulfiller {
    objc_setAssociatedObject(self, fullfillerKey, deallocFulfiller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
