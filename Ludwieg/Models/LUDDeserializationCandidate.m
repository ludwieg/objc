//
//  LUDDeserializationCandidate.m
//  Ludwieg
//
//  Created by Victor Gama on 15/11/2017.
//  Copyright © 2017 Victor Gama. All rights reserved.
//

#import "LUDDeserializationCandidate.h"
#import "LUDTypes.h"
#import "LUDMessageMeta.h"

@implementation LUDDeserializationCandidate

+ (instancetype)candidateWithBuffer:(NSData *)buf andMeta:(LUDMessageMeta *)meta {
    LUDDeserializationCandidate *inst = [[self alloc] init];
    return inst;
}

@end
