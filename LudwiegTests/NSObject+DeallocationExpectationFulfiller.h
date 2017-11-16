//
//  NSObject+DeallocationExpectationFulfiller.h
//  LudwiegTests
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DeallocationExpectationFulfiller;

@interface NSObject (DeallocationExpectationFulfiller)
@property (nonatomic) DeallocationExpectationFulfiller *deallocFulfiller;
@end
