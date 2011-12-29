//
//  UIImageButton.m
//  rlimage
//
//  Created by Ali Nouri on 10/17/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "UIImageButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageButton

@synthesize imageView=_imageView; 


-(void) setImageView:(UINetImageView *)imageView
{
    //remove the old image from subview if present 
    if (_imageView)
    {
        [_imageView removeFromSuperview]; 
    }
    _imageView = imageView; 
    [self addSubview:_imageView];           //this does the retaining stuff
    
}

-(id) initWithImage:(UINetImageView *)img
{
    if (!img) 
        return nil; 
    

    CGRect frame = CGRectMake(0, 0, img.frame.size.width, img.frame.size.height);
    
    self = [super initWithFrame:[img frame]]; //do we need to make the frame larger?
    img.frame = frame; 
    
    if (self)
    {
        self.imageView = img; 

    
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
        self.layer.shadowRadius = 2.0f;
        self.layer.masksToBounds = NO;
        
        //simple drop shadow 
        //    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
        
        CGSize size = self.bounds.size;
        CGFloat curlFactor = 5.0f;
        CGFloat shadowDepth = 2.0f;
         shadowPath= [UIBezierPath bezierPath];
        [shadowPath moveToPoint:CGPointMake(0.0f, 0.0f)];
        [shadowPath addLineToPoint:CGPointMake(size.width, 0.0f)];
        [shadowPath addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
        [shadowPath addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
                controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
                controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];    
        
        self.layer.shadowPath = shadowPath.CGPath; 
    
    
        isPushedDown = NO; 
    }
    
    
    return self; 
}


-(void) dealloc
{
    //the imageview is stored in subview so it'll be freed automatically 
    
    [super dealloc]; 
}

-(void) pushdown
{
    self.layer.masksToBounds = YES;
    CGRect f = self.frame; 
    CGRect newFrame = CGRectMake(f.origin.x+1.5  , f.origin.y+1.5, f.size.width, f.size.height);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveLinear 
                     animations:^{self.frame = newFrame; } 
                     completion:^(BOOL fin) {} ]; 
    
    
    
    [self setNeedsDisplay]; 
}

-(void) popup
{
    self.layer.masksToBounds = NO;
    CGRect f = self.frame; 
    CGRect newFrame = CGRectMake(f.origin.x-1.5  , f.origin.y-1.5, f.size.width, f.size.height);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveLinear 
                     animations:^{self.frame = newFrame; } 
                     completion:^(BOOL fin) {} ]; 
    
    
    [self setNeedsDisplay];     
}



-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isPushedDown)
    {
        [self pushdown]; 
    }
    
    isPushedDown = YES; 
    return YES; 
}




-(void) cancelTrackingWithEvent:(UIEvent *)event
{
    if (isPushedDown)
    {
        isPushedDown = NO; 
        [self popup]; 
    }
}

-(void) endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isPushedDown)
    {
        isPushedDown = NO; 
        [self popup]; 
        [self sendActionsForControlEvents:UIControlEventTouchDown]; 
    }
    
}




@end
