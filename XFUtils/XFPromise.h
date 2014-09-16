//
//  XFPromise.h
//  XFUtils
//
//  Created by Manu Wallner on 11/02/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

@import Foundation;

@interface XFPromise : NSObject <NSCopying>

/**
 *  This block is executed when the promise sucessfully completes
 */
@property (nonatomic, copy, readonly) void (^successBlock)(id);

/**
 *  This block is executed when the promise is rejected
 */
@property (nonatomic, copy, readonly) void (^errorBlock)(NSError *);

/**
 *  This is a running ID that is different for every promise
 */
@property (nonatomic, assign, readonly) uint64_t ID;

/**
 *  The value with which the promise was fulfilled
 */
@property (nonatomic, strong, readonly) id value;

/**
 *  The queue on which the success and error blocks will be executed. If this is nil, then the blocks will be executed on the main thread
 */
@property (nonatomic, strong) dispatch_queue_t runQueue;

/**
 *  Create a new promise
 */
+ (instancetype)promise;

/**
 *  Reject the promise with the specified error.
 *
 *  @param error The error that is passed to the errorBlock
 */
- (void)reject:(NSError *)error;

/**
 *  Fulfill the promise succesfully.
 *
 *  @param value The value that is passed to the successBlock
 */
- (void)fulfill:(id)value;

/**
 *  Set the success and error blocks
 */
- (void)then:(void (^)(id))successBlock error:(void (^)(NSError *))errorBlock;

/**
 *  Only set the success block for when the promise is fulfilled
 */
- (void)then:(void (^)(id))successBlock;

/**
 *  Only set the error block for when the promise is rejected
 */
- (void)error:(void (^)(NSError *))errorBlock;

@end
