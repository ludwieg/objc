//
//  DeallocationExpectationFulfiller.m
//  LudwiegTests
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "DeallocationExpectationFulfiller.h"
#import <XCTest/XCTest.h>

@implementation DeallocationExpectationFulfiller {
    XCTestExpectation *expect;
}

- (instancetype)initWithExpectation:(XCTestExpectation *)expectation {
    if(self = [super init]) {
        expect = expectation;
    }
    return self;
}

- (void)dealloc {
    [expect fulfill];
}

@end
