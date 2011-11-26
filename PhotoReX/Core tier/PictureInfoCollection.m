//
//  PictureInfoCollection.m
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "PictureInfoCollection.h"
#import "PictureInfo.h"

@implementation PictureInfoCollection

@synthesize count = _count; 
@synthesize images = _images; 
@synthesize uniqueID=_uniqueID; 

- (id)initWithCount:(int) c
{
    self = [super init];
    if (self) {
        self.count = c ; 
        
        NSMutableArray* tmpArray = [NSMutableArray arrayWithCapacity:c]; 
        for(int i=0; i< c; i++)
        {
            PictureInfo* tmpObj = [[PictureInfo alloc] init]; 
            
            [tmpArray addObject:tmpObj]; 
            [tmpObj release]; 
        }
        
        self.images = [[[NSArray alloc] initWithArray:tmpArray] autorelease]; 
        
       // [tmpArray release]; 
    }
   
    return self;
}

-(PictureInfo*) getPictureInfoAtLocation:(int)index
{    
    if (index <0 || index >= self.count)
        return nil; 
    
    
    return [self.images objectAtIndex:index]; 
}

-(void) loadPicturesWithData:(NSArray *)data
{
    
    if (data== nil) 
        return; 
    
    if (data.count < self.count)
    {
        NSLog(@"ERROR: received %d pictures in picCollection where needed %d\n", data.count, self.count); 
        return; 
    }
    
    for (int i=0; i< self.count; i++)
    {
        [[self.images objectAtIndex:i] createInfoFromJsonData:[data objectAtIndex:i]]; 
    }
}



-(void) dealloc
{
    [_images release];  
    [_uniqueID release]; 
    
    [super dealloc]; 
}


@end
