//
//  ImageStatusOverlayLayer.m
//  photoRexplore
//
//  Created by Ali Nouri on 11/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "ImageStatusOverlayLayer.h"
#import "PictureInfo.h"

#define STATUS_ICON_WIDTH   15



@implementation ImageStatusOverlayLayer


-(id) initWithPictureInfo:(PictureInfo *)p
{
    self = [super init]; 
    if (self)
    {
        pictureInfo = p; 
    }
    
    return self; 
}


-(void) drawInContext:(CGContextRef)ctx
{
    CGFloat curX = STATUS_ICON_WIDTH; 

    if (pictureInfo.userActivityStatus == ImageActivityStatusVisited)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

        CGRect rect = CGRectMake(curX, 5, 10, 10); 
        UIBezierPath*    p = [UIBezierPath bezierPathWithOvalInRect:rect]; 
        
        [p fill]; 
    }



}





@end
