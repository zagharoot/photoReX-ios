//
//  GraphNode.h
//  photoReX
//
//  Created by Ali Nouri on 2/22/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphChildCategory.h"
#import "PictureInfo.h"
#import "GraphChildCategory.h"


/* This represents a node in the walk graph. It contains a picInfo for the picture and a
    bunch of children from different walk categories.
*/
@interface GraphNode : NSObject

{
    PictureInfo* _picInfo;
    GraphNode* _parent;
    GraphNode* _selectedChild;
    
    NSMutableArray* _children;
}

-(id) initWithPictureInfo:(PictureInfo*) pi andParent:(GraphNode*) p; 
-(void) populateChildren;
-(void) pictureDataBecameAvailable:(PictureInfo*) source; 

@property (retain, nonatomic) PictureInfo* picInfo;
@property (assign, nonatomic) GraphNode* parent;
@property (assign, nonatomic) GraphNode* selectedChild;
@property (retain, nonatomic) NSMutableArray* children;


@end
