//
//  ImageStatusOverlayLayer.m
//  photoRexplore
//
//  Created by Ali Nouri on 11/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "ImageStatusOverlayView.h"
#import "PictureInfo.h"

#define STATUS_ICON_WIDTH   15


@implementation ImageStatusOverlayView


-(id) initWithPictureInfo:(PictureInfo *)p andParentFrame:(CGRect)f
{
    CGRect frame = CGRectMake(0, 0, f.size.width, 20); 
    self = [super initWithFrame:frame]; 
    if (self)
    {
        pictureInfo = p; 
        self.backgroundColor = [UIColor clearColor]; 
        self.opaque = NO; 
        
    }
    
    return self; 
}


-(void) drawRect:(CGRect)rect
{
    CGFloat curX = 5; 

    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context); 
    CGContextSetFillColorWithColor(context, [UIColor colorWithHue:0.0 saturation:0.0 brightness:0 alpha:0.65].CGColor);
    CGContextFillRect(context, self.frame); 
    
    
    UIGraphicsPopContext(); 
    
    if (pictureInfo.userActivityStatus == ImageActivityStatusVisited)
    {
        CGContextSetLineWidth(context, 1);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

        CGRect rect = CGRectMake(curX, 5, 10, 10); 
        UIBezierPath*    p = [UIBezierPath bezierPathWithOvalInRect:rect]; 
        
        [p fill]; 
    }



}





@end
