//
//  XFFuture.m
//  XFUtils
//
//  Created by Manu Wallner on 27/11/12.
//  Copyright (c) 2012 XForge Software Development GmbH. All rights reserved.
//

#import "XFFuture.h"

@interface XFFuture ()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t checkQueue;

@end

@implementation XFFuture
@synthesize value = _value;

- (id)init {
    self = [super init];
    if (self) {
        _value = nil;
        _semaphore = dispatch_semaphore_create(0);
        _timeout = 60; // 1min
        _checkQueue = dispatch_queue_create("at.xforge.future-synchronization-queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)setValue:(id)value {
    dispatch_async(_checkQueue, ^{
        if (!value || value == _value) return;
        _value = value;
        while (dispatch_semaphore_signal(_semaphore)) {
        }
    });
}

- (id)value {
    id __block value;
    dispatch_sync(_checkQueue, ^{ value = _value; });
    if (value) return value;
    dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, _timeout * 1e9));
    dispatch_sync(_checkQueue, ^{
        if (!_value) _value = NSNull.null; // timeout
    });
    return _value;
}

- (void)abort {
    self.value = NSNull.null;
}

@end
