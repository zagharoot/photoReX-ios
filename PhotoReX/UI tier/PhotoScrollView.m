//
//  PhotoScrollView.m
//  rlimage
//
//  Created by Ali Nouri on 10/26/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "PhotoScrollView.h"

@implementation PhotoScrollView

@synthesize imageView=_imageView; 


-(void) setImageView:(UIView *)contentView
{
    [_imageView release]; 
    _imageView = [contentView retain]; 
    

    [self addSubview:self.imageView]; 
}


- (void)layoutSubviews {
    [super layoutSubviews];

    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.imageView.frame = frameToCenter;
}


-(void) dealloc
{
    [_imageView release]; 
    
    [super dealloc]; 
}

@end
