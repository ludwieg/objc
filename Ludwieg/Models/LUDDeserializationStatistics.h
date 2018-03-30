//
//  LUDDeserializationResult.h
//  Ludwieg
//
//  Created by Victor Gama on 30/03/2018.
//  Copyright © 2018 Victor Gama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LUDDeserializationStatistics : NSObject


/**
 Represents the quantity of fields received from the remote server.
 */
@property (nonatomic, readonly) uint32_t receivedFields;


/**
 Represents the quantity of fields applied on the local model.
 */
@property (nonatomic, readonly) uint32_t appliedFields;


/**
 Indicates whether the local model was able to pick all changes included in
 the parsed package. When false, indicates that the local model is out of sync
 with the remote server.
 */
@property (nonatomic, readonly) BOOL knowsAllFields;

+ (nonnull instancetype)resultWithReceivedFields:(uint32_t)aReceived andApplied:(uint32_t)anApplied;

@end
