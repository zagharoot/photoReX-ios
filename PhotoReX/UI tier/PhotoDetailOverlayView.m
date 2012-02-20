//
//  PhotoDetailOverlayView.m
//  photoReX
//
//  Created by Ali Nouri on 12/24/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "PhotoDetailOverlayView.h"

@implementation PhotoDetailOverlayView
@synthesize pictureInfo=_pictureInfo; 



-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder]; 
    
    if (self) 
    {
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGFloat colors[] =
        {
            0.0f, 0.0f, 0.0f, 0.5f,
            0.0f, 0.0f, 0.0f, 0.0f,
        };
        gradientRef = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
        CGColorSpaceRelease(rgb);
    }
    return self; 
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGRect b = self.bounds;

    CGFloat lineMargin = 15; 
    CGFloat topLineHeight = 65; 
    CGFloat bottomLineHeight = b.size.height - 60; 
    
    
    
    CGContextMoveToPoint(context, lineMargin , topLineHeight);
    CGContextAddLineToPoint(context, b.size.width-lineMargin, topLineHeight); 
    
    
    CGContextMoveToPoint(context, lineMargin, bottomLineHeight);
    CGContextAddLineToPoint(context, b.size.width-lineMargin, bottomLineHeight); 
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPoint start = CGPointMake(100, 0  ); 
    CGPoint end = CGPointMake(100, topLineHeight+20);
    CGContextDrawLinearGradient(context, gradientRef, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);

    start = CGPointMake(100, b.size.height  ); 
    end = CGPointMake(100, bottomLineHeight-50);
    CGContextDrawLinearGradient(context, gradientRef, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    [super drawRect:rect]; 
}

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event]; 
    
    if (result==self) 
        return nil; 
    else 
        return result; 
}


@end
