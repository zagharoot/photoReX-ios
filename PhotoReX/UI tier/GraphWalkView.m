//
//  GraphWalkView.m
//  photoReX
//
//  Created by Ali Nouri on 3/3/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "GraphWalkView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GraphWalkView
@synthesize page=_page;
@synthesize node=_node;

-(id) initWithNode:(GraphNode *)node andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.node = node;
        
        
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
        self.layer.shadowOffset = CGSizeMake(3,3);
        self.layer.shadowRadius = 2;
        self.layer.shadowOpacity = 0.5;

        
        //the position of the main node
        CGFloat w = frame.size.width;
 //       CGFloat h = frame.size.height;

        CGFloat ypadding = 30;
        CGFloat mainNodeRadius = w/6;
        
        
        
        CGRect mainNodeFrame = CGRectMake(w/2-mainNodeRadius, ypadding , 2*mainNodeRadius  , 2*mainNodeRadius);
        mainPigImageView = [[GraphNodeImageView alloc] initWithPictureInfo:self.node.picInfo andFrame:mainNodeFrame];
        [self addSubview:mainPigImageView];
    }
    return self; 
}


-(void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"drawing node"); 
    //draw the partial sun
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    
    CGRect mf = mainPigImageView.frame;

    
    // -------------- drawing the dotted line if we are not the first page
    UIBezierPath* p1 = [UIBezierPath bezierPath];

    if (! self.node.parent)
    {
        CGPoint sp = CGPointMake(mf.origin.x + mf.size.width/2, mf.origin.y - 5);
        CGPoint ep = CGPointMake(sp.x, 5);
        [p1 moveToPoint:sp];
        [p1 setLineWidth:5];
        [p1 addLineToPoint:ep]; 
        
        
        float dash []= {3,3};
        [p1 setLineDash:dash count:2 phase:2];

        [p1 stroke]; 
        
    }
    
    
    
    // -------------- drawing the bezier paths from main node to each category
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGPoint sp = CGPointMake(mf.origin.x + mf.size.width/2, mf.origin.y + mf.size.height + 5);
    int cats = 3; //self.node.children.count;
    CGFloat endPadding = 30;
    for(int i=0; i< cats; i++)
    {
        CGPoint ep = CGPointMake(endPadding + i*(rect.size.width - 2*endPadding)/(cats-1), rect.size.height/2);
        CGPoint cp1 = CGPointMake(sp.x, (ep.y+sp.y)/2);
        CGPoint cp2 = CGPointMake(ep.x, (ep.y+sp.y)/2);
        [path moveToPoint:sp];
        [path addCurveToPoint:ep controlPoint1:cp1 controlPoint2:cp2];
        
    }
    
    
//    [path setLineDash:nil count:0 phase:0];
    [path setLineWidth:3];
    [[UIColor yellowColor] setStroke];
    [path stroke];
    
}


-(void) layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"laying out my subviews");
}

-(void) dealloc
{
    [mainPigImageView release]; 
    
    [super dealloc];
}


@end
