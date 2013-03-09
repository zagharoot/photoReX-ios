//
//  GraphWalkView.m
//  photoReX
//
//  Created by Ali Nouri on 3/3/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "GraphWalkView.h"

@implementation GraphWalkView
@synthesize page=_page;
@synthesize node=_node;

-(id) initWithNode:(GraphNode *)node andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.node = node;
        CGRect mainNodeFrame = CGRectMake(50, 50, 100, 100);
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
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    
    //location of sun in iphones
    CGPoint center = CGPointMake(20, 20);
    CGFloat radius = 10;
    
    CGFloat degree = 2*M_PI;
    UIBezierPath*    p = [UIBezierPath bezierPath];
    
    [p moveToPoint:center];
    [p addLineToPoint:CGPointMake(center.x, center.y-radius)];
    [p addArcWithCenter:center radius:radius startAngle:-M_PI_2 endAngle:(-M_PI_2+degree) clockwise:YES];
    [p closePath];
    
    p.lineWidth = 5;
    
    //    p.usesEvenOddFillRule = YES;
    [p fill];
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
