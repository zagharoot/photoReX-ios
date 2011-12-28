//
//  ExploreImageProvider.m
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "ExploreImageProvider.h"


const int CACHED_PAGES  =  1;           //number of pages retrieved in advance


@implementation ExploreImageProvider

@synthesize pages=_pages; 

- (id)init
{
    self = [super init];
    if (self) {
        _pages = [[NSMutableArray alloc] initWithCapacity:20]; 
        // Initialization code here.
        
        webservice = [RLWebserviceClient standardClient]; 
    }
    
    return self;
}


//This function creates an object of pictureInfoCollection and returns an autoreleased version instantly. 
//It also tries to load the data for each pictureInfo in the background. 
-(PictureInfoCollection*) retrievePageAsync:(int) howMany
{
    PictureInfoCollection* result = [[PictureInfoCollection alloc] initWithCount:howMany]; 
    
    [webservice getPageFromServerAsync:howMany andRunBlock:
     ^(NSString* pageid, NSArray* picInfoData)
     {
         result.uniqueID = pageid; 
         [result loadPicturesWithData:picInfoData]; 
     }]; 
    
    return [result autorelease]; 
}


-(id) getContentAtPage:(int)p
{
    
    //this is the easy part, we just want a page from middle and we don't even hit the need-to-get-more-for-cache border
    int gholi = self.pages.count - CACHED_PAGES; 
    if (p < gholi)         
        return [self.pages objectAtIndex:p]; 
    
    
    if (p> self.pages.count+1)          //asking for pages beyond what we already have
        return nil; 
    
    int count = self.pages.count ; 
    for (int i=0; i<= (CACHED_PAGES - (count-p)); i++)
    {
        PictureInfoCollection* page = [self retrievePageAsync:12];  //TODO: fix 12
        [self.pages addObject:page]; 
    }
    
    return [self.pages objectAtIndex:p];     
}


-(void) userVisitsImageAtIndex:(int)indx inPictureInfoCollection:(PictureInfoCollection *)picCollection
{
    [webservice sendPageActivityAsync:picCollection.uniqueID pictureIndex:indx]; 
}


-(void) dealloc
{
    self.pages = nil; 
    [super dealloc]; 
}



@end
