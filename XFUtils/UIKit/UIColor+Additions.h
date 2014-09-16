//
//  UIColor.h
//  XFUtils
//
//  Created by Manu Wallner on 16/09/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface UIColor (Additions)

- (UIColor *)darkerColor;
- (UIColor *)darkerColorWithAlpha:(CGFloat)alpha;
- (UIColor *)brighterColor;
- (UIColor *)brighterColorWithAlpha:(CGFloat)alpha;

@end
