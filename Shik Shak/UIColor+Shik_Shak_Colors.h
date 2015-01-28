//
//  UIColor+Shik_Shak_Colors.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Shik_Shak_Colors)

+ (UIColor *)themeColor;
+ (UIColor *)themeColorTranslucent;

+ (UIColor *)charcoalColor;
+ (UIColor *)lighterGrayColor;
+ (UIColor *)salmonColor;
+ (UIColor *)turquoiseColor;
+ (UIColor *)pumpkinColor;
+ (UIColor *)colorWithOpacityFromColor:(UIColor *)color;

@end
