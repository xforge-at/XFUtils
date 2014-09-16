//
//  XFAnimator.m
//  XFUtils
//
//  Created by Manu Wallner on 16/09/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

#import "XFAnimator.h"

@interface XFAnimator ()
@property (nonatomic, weak, readwrite) UIViewController *presentingViewController;
@property (nonatomic, weak, readwrite) UIViewController *presentedViewController;
@end

@implementation XFAnimator

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.presentedViewController = [transitionContext viewControllerForKey:self.isPresenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey];
    self.presentingViewController = [transitionContext viewControllerForKey:self.isPresenting ? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(NO, @"You have to overwrite this method in a subclass");
    return 0;
}

@end
