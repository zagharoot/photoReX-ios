//
//  GraphWalkView.h
//  photoReX
//
//  Created by Ali Nouri on 3/3/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphNode.h"
#import "GraphNodeImageView.h"

// this class draws a page in our graph walk which has a main node and its categories.


@interface GraphWalkView : UIView
{
    int _page;      //what page we are in
    GraphNode* _node;   //the corresponding graph node that holds the data structure
    
    
    GraphNodeImageView* mainPigImageView;
    
}

@property (nonatomic) int page; 
@property (nonatomic, retain) GraphNode* node;

-(id) initWithNode:(GraphNode*) node andFrame:(CGRect) frame; 
@end
