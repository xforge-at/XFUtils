//
//  XFPromise.m
//  XFUtils
//
//  Created by Manu Wallner on 11/02/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

#import "XFPromise.h"

typedef enum OAPromiseState { OAPromiseStatePending, OAPromiseStateFulfilled, OAPromiseStateRejected } OAPromiseState;

@interface XFPromise ()

@property (nonatomic, copy, readwrite) void (^successBlock)(id);
@property (nonatomic, copy, readwrite) void (^errorBlock)(NSError *);
@property (nonatomic, assign, readwrite) uint64_t ID;
@property (nonatomic, strong, readwrite) id value;
@property (nonatomic, strong, readwrite) NSError *error;

@property (nonatomic, assign) OAPromiseState currentState;

@end

@implementation XFPromise

+ (instancetype)promise {
    return [[XFPromise alloc] init];
}

static uint64_t IDS = 0;

- (id)init {
    self = [super init];
    if (self) {
        _ID = IDS++;
        _currentState = OAPromiseStatePending;
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
}

- (BOOL)changeState:(OAPromiseState)toState {
    switch (self.currentState) {
        case OAPromiseStatePending:
            break;
        case OAPromiseStateRejected:
        case OAPromiseStateFulfilled:
            return YES;
    }
    switch (toState) {
        case OAPromiseStateFulfilled:
            [self runBlock:self.successBlock withValue:self.value];
            break;
        case OAPromiseStateRejected:
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
        if (promise.currentState != OAPromiseStatePending) return;
        _value = value;
        [promise changeState:OAPromiseStateFulfilled];
    });
}

- (void)reject:(NSError *)error {
    __weak XFPromise *weakSelf = self;
    dispatch_async(self.isolationQueue, ^{
        XFPromise *promise = weakSelf;
        if (promise.currentState != OAPromiseStatePending) return;
        _error = error;
        [promise changeState:OAPromiseStateRejected];
    });
}

- (void)then:(void (^)(id))successBlock error:(void (^)(NSError *))errorBlock {
    __weak XFPromise *weakSelf = self;
    dispatch_async(self.isolationQueue, ^{
        XFPromise *promise = weakSelf;
        if (errorBlock) _errorBlock = errorBlock;
        if (successBlock) _successBlock = successBlock;
        switch (promise.currentState) {
            case OAPromiseStateFulfilled:
                [promise runBlock:_successBlock withValue:promise.value];
                break;
            case OAPromiseStateRejected:
                [promise runBlock:_errorBlock withValue:promise.error];
                break;
            default:
                break;
        }
    });
}

- (void)then:(void (^)(id))successBlock {
    [self then:successBlock error:nil];
}

- (void)error:(void (^)(NSError *))errorBlock {
    [self then:nil error:errorBlock];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
