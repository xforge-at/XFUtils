//
//  UIImage+Additions.m
//  XFUtils
//
//  Created by Manu Wallner on 28/03/13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)imageWithColor:(UIColor *)color {
    NSParameterAssert(color);
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageWithLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0.0f);

    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return outputImage;
}

+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

- (UIImage *)imageTintedWithColor:(UIColor *)color {
    NSParameterAssert(color);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);

    [self drawInRect:rect];
    [color set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeMultiply);
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)imageByMergingWithImage:(UIImage *)other {
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:bounds];
    [other drawInRect:bounds];

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

@end