//
//  UIWaveView.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/20/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "UIWaveView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIWaveView
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetRGBStrokeColor(context, 25, 25, 25, 1.0);
    CGMutablePathRef path = CGPathCreateMutable();
    float x=75;
    float y = rect.size.height;
    float yc=20;
    float w=0;
    while (w <= rect.size.width) {
        
        
        CGPathMoveToPoint(path, nil, w,y/2);
        CGPathAddQuadCurveToPoint(path, nil, w+x/4, -yc,w+ x/2, y/2);
        CGPathMoveToPoint(path, nil, w+x/2,y/2);
        CGPathAddQuadCurveToPoint(path, nil, w+3*x/4, y+yc, w+x, y/2);
        CGContextAddPath(context, path);
        CGContextDrawPath(context, kCGPathStroke);
        w+=x;
    }

}

@end
