//
//  XFNetworkThread.h
//  XFUtils
//
//  Created by Stefan Draskovits on 21/02/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFNetworkThread : NSThread

/**
 *  Returns the App's dedicated network thread
 *
 *  @return The network thread
 */
+ (instancetype)sharedNetworkThread;

/**
 *  Executes a block on the network thread - you can safely run NSURLConnection and friends in this block
 *
 *  @param block The block to execute
 */
- (void)executeBlock:(dispatch_block_t)block;

@end
