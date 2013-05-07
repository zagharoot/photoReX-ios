//
//  GraphNodeImageView.m
//  photoReX
//
//  Created by Ali Nouri on 3/4/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "GraphNodeImageView.h"
#import <QuartzCore/CAShapeLayer.h>


@implementation GraphNodeImageView




-(id) initWithPictureInfo:(PictureInfo *)pictureInfo andFrame:(CGRect)frame
{
    self = [super initWithPictureInfo:pictureInfo andFrame:frame shouldClipToBound:NO drawUserActivity:NO isFullScreen:NO];
    
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.clipsToBounds = NO;
    
    
    UIBezierPath* p= [UIBezierPath bezierPath];
//    [p moveToPoint:CGPointMake(0.0f,0.0f)];
    
    CGFloat xc = self.bounds.size.width/2;
    CGFloat yc = self.bounds.size.height/2; 
    
    
    [p addArcWithCenter:CGPointMake(xc,yc) radius:MIN(xc, yc) startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    
    CAShapeLayer* mLayer = [[CAShapeLayer alloc] init];
    mLayer.frame = self.bounds;
    mLayer.path = p.CGPath;
    self.layer.Mask = mLayer;
    
    return self;
}


-(void) imageDidBecomeAvailable:(UIImage *)theImage
{
    CGRect r = CGRectMake(0, 0, theImage.size.width, theImage.size.height); 
        double factor = 2;

    if (theImage.size.width > theImage.size.height)
    {
        r.size.width = r.size.height;
        r.origin.x = (theImage.size.width - theImage.size.height)/2.0;
    }else {
        r.size.height = r.size.width;
        r.origin.y = (theImage.size.height - theImage.size.width)/2.0;
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([theImage CGImage], r);
        
    theImage = [UIImage imageWithCGImage:imageRef scale:factor orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);

    self.tmpImage = theImage;
    
    double loadDelay = 0;
    if ([[NSDate date] timeIntervalSince1970] - loadStartTime > 0.8)
        loadDelay = 0.15;
    
    [NSTimer scheduledTimerWithTimeInterval:loadDelay target:self selector:@selector(becomeAvailable) userInfo:nil repeats:NO];
}


-(void) drawRect:(CGRect)rect
{
    //this is not even called. i dont know why
/*    CGFloat centerX = rect.size.width/2;
    CGFloat centerY = rect.size.height/2;
    CGFloat radius = 30; 
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context,centerX,centerY,radius,0,2*M_PI,1);
    CGContextDrawPath(context,kCGPathStroke);
*/
}



@end
