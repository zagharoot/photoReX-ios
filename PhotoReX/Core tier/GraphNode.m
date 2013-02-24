//
//  GraphNode.m
//  photoReX
//
//  Created by Ali Nouri on 2/22/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "GraphNode.h"

@implementation GraphNode

@synthesize picInfo=_picInfo;
@synthesize children=_children;
@synthesize selectedChild=_selectedChild;
@synthesize parent=_parent;


-(id) initWithPictureInfo:(PictureInfo *)pi andParent:(GraphNode *)p
{
    self = [super init];
    
    if (self) {
        self.parent = p;
        self.picInfo = pi;
        
        self.selectedChild = NULL;
        self.children = [[[NSMutableArray alloc] init] autorelease];
        
    }
    
    
    return self ;
}


//generates children for the current node
-(void) populateChildren
{
    GraphSameUserCategory* tmp1 = [[GraphSameUserCategory alloc] init];
    [self.children addObject:tmp1];
    
    GraphUserContactsCategory* tmp2 = [[GraphUserContactsCategory alloc] init];
    [self.children addObject:tmp2];
    
    GraphUserFavoriteCategory* tmp3 = [[GraphUserFavoriteCategory alloc] init];
    [self.children addObject:tmp3];
    

    if (self.picInfo && self.picInfo.isInfoDataAvailable)
    {
        tmp1.picInfoDetail = self.picInfo.info;
        tmp2.picInfoDetail = self.picInfo.info;
        tmp3.picInfoDetail = self.picInfo.info;
    }else if (self.picInfo)
    {
        //the picture info data is not ready yet. register for notification so we can pass on info later
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureDataBecameAvailable:) name:@"PictureInfoImageActivityStatusDidChange" object:self.picInfo];
    }
}


-(void) pictureDataBecameAvailable:(PictureInfo *)source
{
    
    for(GraphChildCategory *cat in self.children)
    {
        cat.picInfoDetail = source.info;
    }
}

-(void) dealloc
{
    self.children = NULL;
    self.picInfo = NULL;
    
    [super dealloc];
}


@end
