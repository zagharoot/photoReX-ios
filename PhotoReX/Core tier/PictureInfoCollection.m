//
//  PictureInfoCollection.m
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "PictureInfoCollection.h"
#import "PictureInfo.h"
#import "NSError+Util.h"

@implementation PictureInfoCollection

@synthesize count = _count; 
@synthesize images = _images; 
@synthesize uniqueID=_uniqueID; 
@synthesize errorMessage=_errorMessage; 

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

-(int) getIndexOfPictureInfo:(PictureInfo *)pic
{

    for (int i=0; i< self.images.count; i++)
        if ([self.images objectAtIndex:i]==pic)
            return i; 
    
    
    return -1; 
    
}


-(void) loadPicturesWithData:(NSArray *)data 
{
    
    if (data== nil) 
        return; 
    
    if (data.count < self.count)
    {
        NSLog(@"ERROR: received %d pictures in picCollection where needed %d\n", data.count, self.count); 
        self.errorMessage = [NSError errorWithDomain:@"rlwebserver" andMessage:[NSString stringWithFormat:@"ERROR: received %d pictures in picCollection where needed %d\n", data.count, self.count]];
        return; 
    }
    
    for (int i=0; i< self.count; i++)
    {
        NSError* err = [[self.images objectAtIndex:i] createInfoFromJsonData:[data objectAtIndex:i]]; 
        if (err)
            self.errorMessage = err; 
    }
}



-(void) dealloc
{
    [_images release];  
    [_uniqueID release]; 
    [_errorMessage release]; 
    
    [super dealloc]; 
}


@end
