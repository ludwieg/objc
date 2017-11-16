//
//  LUDErrorDomain.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDErrorDomain.h"

@implementation LUDErrorDomain

+ (NSString *)errorDomain {
    return @"LudwiegErrorDomain";
}

+ (NSError *)errorWithCode:(LUDError)error {
    return [NSError errorWithDomain:[self errorDomain] code:error userInfo:nil];
}

@end
