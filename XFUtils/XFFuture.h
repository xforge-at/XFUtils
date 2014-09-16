//
//  XFFuture.h
//  XFUtils
//
//  Created by Manu Wallner on 27/11/12.
//  Copyright (c) 2012 XForge Software Development GmbH. All rights reserved.
//

@import Foundation;

@interface XFFuture : NSObject

/**
 *  Abort and return NSNull.null on the receiving end of the future
 */
- (void)abort;

/**
 *  Getting the value will block until either a value is set or the timeout has passed. Setting it will notify waiting threads about the new value. Note that once a value was set, the getter will
 * always return immediatelly.
 */
@property (nonatomic, strong) id value;

/**
 *  The timeout in seconds.
 */
@property (nonatomic, assign) NSTimeInterval timeout;

@end