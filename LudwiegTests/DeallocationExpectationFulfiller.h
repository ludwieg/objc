//
//  DeallocationExpectationFulfiller.h
//  LudwiegTests
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCTestExpectation;

@interface DeallocationExpectationFulfiller : NSObject

- (instancetype)initWithExpectation:(XCTestExpectation *)expectation;

@end
