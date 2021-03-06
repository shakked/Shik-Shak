//
//  UIColor+Shik_Shak_Colors.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/19/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "UIColor+Shik_Shak_Colors.h"
#import "ZSSUser.h"
#import "ZSSLocalQuerier.h"

@implementation UIColor (Shik_Shak_Colors)

+ (UIColor *)themeColor {
    return [[[ZSSLocalQuerier sharedQuerier] currentUser] themeColor];
}

+ (UIColor *)themeColorTranslucent {
    return [self colorWithOpacityFromColor:[self themeColor]];
}

+ (UIColor *)charcoalColor {
    return [UIColor colorWithRed:59.0/255
                           green:59.0/255
                            blue:59.0/255
                           alpha:1.0];
}

+ (UIColor *)lighterGrayColor {
    return [UIColor colorWithRed:200.0/255
                           green:200.0/255
                            blue:200.0/255
                           alpha:1.0];
}

+ (UIColor *)salmonColor {
    return [UIColor colorWithRed:255.0/255
                           green:83.0/255
                            blue:74.0/255
                           alpha:1.0];
}

+ (UIColor *)turquoiseColor {
    return [UIColor colorWithRed:0.0/255
                           green:199.0/255
                            blue:120.0/255
                           alpha:1.0];
}

+ (UIColor *)pumpkinColor {
    return [UIColor colorWithRed:211.0/255
                           green:84.0/255
                            blue:0.0/255
                           alpha:1.0];
}

+ (UIColor *)colorWithOpacityFromColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:0.2];
    
}

@end
