//
//  UIImage+Additions.h
//  XFUtils
//
//  Created by Manu Wallner on 28/03/13.
//  Copyright (c) 2013 XForge Software Development GmbH. All rights reserved.
//

@import UIKit;

@interface UIImage (Additions)

/**
 *  Creates an image filled with the specified color.
 *
 *  @param color The new image's background color
 *
 *  @return A new 1x1 image that is completely filled with the color
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  Draws a layer into a new UIImage with the same dimensions
 *
 *  @param layer The layer to create the image from
 *
 *  @return A new UIImage with the same dimensions and content as the layer
 */
+ (UIImage *)imageWithLayer:(CALayer *)layer;

/**
 *  Draw a view into a new UIImage with the same dimensions
 *
 *  @param view The view to create the image from
 *
 *  @return A new UIImage with the same dimensions and content as the view
 */
+ (UIImage *)imageWithView:(UIView *)view;

/**
 *  Takes an existing image and tints it. Needs a white image to produce the right colors.
 *
 *  @param color The color the image is tinted with
 *
 *  @return A copy of the existing image that is tinted with the color.
 */
- (UIImage *)imageTintedWithColor:(UIColor *)color;

/**
 *  Overlays an image over the receiver.
 *
 *  @param image The image to overlay with
 *
 *  @return A copy of the existing image with the other image overlayed on top.
 */
- (UIImage *)imageByMergingWithImage:(UIImage *)image;

@end
