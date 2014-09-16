//
//  UIColor.m
//  XFUtils
//
//  Created by Manu Wallner on 16/09/14.
//  Copyright (c) 2014 XForge Software Development GmbH. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

static CGFloat change = 0.3;

- (UIColor *)darkerColor {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) return [UIColor colorWithRed:MAX(r - change, 0.0) green:MAX(g - change, 0.0) blue:MAX(b - change, 0.0) alpha:MIN(a + change, 1.0)];
    return nil;
}

- (UIColor *)brighterColor {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a]) return [UIColor colorWithRed:MIN(r + change, 1.0) green:MIN(g + change, 1.0) blue:MIN(b + change, 1.0) alpha:a];
    return nil;
}

- (UIColor *)darkerColorWithAlpha:(CGFloat)a {
    CGFloat r, g, b;
    if ([self getRed:&r green:&g blue:&b alpha:nil]) return [UIColor colorWithRed:MAX(r - change, 0.0) green:MAX(g - change, 0.0) blue:MAX(b - change, 0.0) alpha:a];
    return nil;
}

- (UIColor *)brighterColorWithAlpha:(CGFloat)a {
    CGFloat r, g, b;
    if ([self getRed:&r green:&g blue:&b alpha:nil]) return [UIColor colorWithRed:MIN(r + change, 1.0) green:MIN(g + change, 1.0) blue:MIN(b + change, 1.0) alpha:a];
    return nil;
}

@end
