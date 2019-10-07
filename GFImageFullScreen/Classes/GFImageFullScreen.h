//
//  GFImageFullScreen.h
//  Fanfa
//
//  Created by Guido Fanfani on 07/10/19.
//  Copyright © 2019 Fanfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFImageFullScreen : UIView

+ (void)showFromImageView:(UIImageView*)imageView;

#pragma mrk - Customizable

/**
 Set background color
 @param color background color of image. default: clearColor
 */
+ (void)setBackgroundColor:(UIColor*)color;

/**
 Set border color
 @param color background color of image. default: whiteColor
 */
+ (void)setBorderColor:(UIColor*)color;

/**
 Set border width
 @param width border. default: 4
 */
+ (void)setBorderWidth:(int)width;

/**
 Set border width
 @param radius radius. default: -1 (circle)
 */
+ (void)setCornerRadius:(int)radius;

/**
 Set border width
 @param margin of image from screen. default: 4
 */
+ (void)setMargin:(float)margin;

@end
