//
//  GraphWalkUIViewController.h
//  photoReX
//
//  Created by Ali Nouri on 3/3/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphNode.h"
#import "GraphWalkView.h"

@interface GraphWalkUIViewController : UIViewController
{
    NSMutableArray* pages;       //contains array of GraphWalkView (0 has the page for root)
    GraphNode* _root;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) GraphNode* root;

-(id) initWithRoot:(GraphNode*) root; 


-(void) expand:(GraphNode*) parent withChild:(GraphNode*) child atPage:(int) p; 

@end