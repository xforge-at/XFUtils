//
//  XFPromise.m
//  iXF
//
//  Created by Manu Wallner on 11/02/14.
//  Copyright (c) 2014 ETM. All rights reserved.
//

#import "XFPromise.h"

typedef enum XFPromiseState { XFPromiseStatePending, XFPromiseStateFulfilled, XFPromiseStateRejected } XFPromiseState;

@interface XFPromise ()

@property (nonatomic, copy, readwrite) void (^successBlock)(id);
@property (nonatomic, copy, readwrite) void (^errorBlock)(NSError *);
@property (nonatomic, assign, readwrite) uint64_t ID;
@property (nonatomic, strong, readwrite) id value;
@property (nonatomic, strong, readwrite) NSError *error;

@property (nonatomic, assign) XFPromiseState currentState;

@end

@implementation XFPromise

+ (instancetype)promise {
    return [[XFPromise alloc] init];
}

static uint64_t IDS = 0;

- (id)init {
    self = [super init];
    if (self) {
        self.children = @[];
        _ID = IDS++;
        _currentState = XFPromiseStatePending;
    }
    return self;
}

static dispatch_queue_t _isolationQueue;
- (dispatch_queue_t)isolationQueue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ _isolationQueue = dispatch_queue_create("at.xforge.promiseQueue", NULL); });
    return _isolationQueue;
}

- (void)runBlock:(void (^)(id))block withValue:(id)value {
    if (block) {
        if (self.runQueue) {
            dispatch_async(self.runQueue, ^{ block(value); });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{ block(value); });
        }
    }
    [_children enumerateObjectsUsingBlock:^(XFPromise *child, NSUInteger idx, BOOL *stop) {
        if (self.error) {
            [child reject:self.error];
        } else if (self.value) {
            [child fulfill:self.value];
        }
    }];
}

- (BOOL)changeState:(XFPromiseState)toState {
    switch (self.currentState) {
        case XFPromiseStatePending:
            break;
        case XFPromiseStateRejected:
        case XFPromiseStateFulfilled:
            return YES;
    }
    switch (toState) {
        case XFPromiseStateFulfilled:
            [self runBlock:self.successBlock withValue:self.value];
            break;
        case XFPromiseStateRejected:
            [self runBlock:self.errorBlock withValue:self.error];
            break;
        default:
            return YES;
    }
    self.currentState = toState;
    return NO;
}

- (void)fulfill:(id)value {
    __weak XFPromise *weakSelf = self;
    dispatch_async(self.isolationQueue, ^{
        XFPromise *promise = weakSelf;
        if (promise.currentState != XFPromiseStatePending) return;
        _value = value;
        [promise changeState:XFPromiseStateFulfilled];
    });
}

- (void)reject:(NSError *)error {
    __weak XFPromise *weakSelf = self;
    dispatch_async(self.isolationQueue, ^{
        XFPromise *promise = weakSelf;
        if (promise.currentState != XFPromiseStatePending) return;
        _error = error;
        [promise changeState:XFPromiseStateRejected];
    });
}

- (XFPromise *)then:(void (^)(id))successBlock error:(void (^)(NSError *))errorBlock {
    __weak XFPromise *weakSelf = self;
    XFPromise *returnPromise = [self returnDescendant];
    dispatch_async(self.isolationQueue, ^{
        XFPromise *promise = weakSelf;
        if (errorBlock) _errorBlock = errorBlock;
        if (successBlock) _successBlock = successBlock;
        switch (promise.currentState) {
            case XFPromiseStateFulfilled:
                [promise runBlock:_successBlock withValue:promise.value];
                break;
            case XFPromiseStateRejected:
                [promise runBlock:_errorBlock withValue:promise.error];
                break;
            default:
                break;
        }
    });
    return returnPromise;
}

- (XFPromise *)then:(void (^)(id))successBlock {
    return [self then:successBlock error:nil];
}

- (XFPromise *)error:(void (^)(NSError *))errorBlock {
    return [self then:nil error:errorBlock];
}

- (XFPromise *)returnDescendant {
    XFPromise *newPromise = [XFPromise promise];
    newPromise.runQueue = self.runQueue;
    self.children = [self.children arrayByAddingObject:newPromise];
    return newPromise;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end