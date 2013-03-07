//
//  GraphNodeImageView.m
//  photoReX
//
//  Created by Ali Nouri on 3/4/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "GraphNodeImageView.h"

@implementation GraphNodeImageView



//initializes and displays a default picture indicating the image is not still available
-(void) loadAsUnavailableImage
{

}




- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat x = self.bounds.size.width/2.0;
    CGFloat y = self.bounds.size.height/2.0;
    CGFloat r = 30;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, x, y , r , 0, 2*M_PI, YES);
    CGContextClosePath(context);
    CGContextClip(context);
}

@end
