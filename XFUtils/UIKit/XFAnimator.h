//
//  XFAnimator.h
//  XFUtils
//
//  Created by Manu Wallner on 16/09/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;

/**
 *  Superclass for UIKit Transition animators
 */
@interface XFAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  The UIViewController that is presenting the other viewController
 */
@property (nonatomic, weak, readonly) UIViewController *presentingViewController;

/**
 *  The UIViewController that is being presented by the presentingViewController
 */
@property (nonatomic, weak, readonly) UIViewController *presentedViewController;

/**
 *  Set to YES in animationControllerForPresentedController:presentingController:sourceController: and to NO otherwise
 */
@property (nonatomic, assign, getter=isPresenting) BOOL presenting;

@end
