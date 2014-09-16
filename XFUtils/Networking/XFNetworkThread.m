//
//  XFNetworkThread.h
//  XFUtils
//
//  Created by Stefan Draskovits on 21/02/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

#import "XFNetworkThread.h"
#import <pthread.h>

@interface XFNetworkThread ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@end

@implementation XFNetworkThread

static XFNetworkThread *sharedThread = nil;

+ (instancetype)sharedNetworkThread {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedThread = [XFNetworkThread new]; });
    return sharedThread;
}

- (id)init {
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return self;
}

- (void)start {
    [super start];
}

- (void)main {
    self.name = @"at.xforge.networking";
    pthread_setname_np(self.name.UTF8String);

    @autoreleasepool {
        while (!self.isCancelled) {
            if (![NSRunLoop.currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
                // If there are no sources in runloop, runMode:beforeDate: returns NO immediatelly ->
                // we need to sleep for some time so this doesn't eat up 100% CPU
                // however, we use a semaphore, because we want to be notified immediatelly
                // in case we have to process a new network request
                dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
            }
        }
    }
}

- (void)executeBlock:(dispatch_block_t)block {
    [self performSelector:@selector(_executeBlock:)
                 onThread:self
               withObject:[block copy] // copy block to be safe
            waitUntilDone:NO];
    dispatch_semaphore_signal(_semaphore);
}

- (void)_executeBlock:(dispatch_block_t)block {
    block();
}

@end
