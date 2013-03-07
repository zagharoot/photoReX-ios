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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id) initWithNode:(GraphNode *)node
{
    self = [super init];
    if (self) {
        self.node = node;

        
        CGRect mainNodeFrame = CGRectMake(50, 50, 100, 100);
        mainPigImageView = [[GraphNodeImageView alloc] initWithPictureInfo:self.node.picInfo andFrame:mainNodeFrame];
        [self addSubview:mainPigImageView];
        
        
    }
    return self; 
}

- (void)drawRect:(CGRect)rect
{
}


-(void) layoutSubviews
{
    
}

-(void) dealloc
{
    [mainPigImageView release]; 
    
    [super dealloc];
}


@end
