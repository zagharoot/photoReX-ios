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
     ^(NSString* pageid, NSArray* picInfoData, NSError* err)
     {
         result.uniqueID = pageid; 
         if (picInfoData && !err)
         {
             [result loadPicturesWithData:picInfoData]; 
             if ([result.delegate respondsToSelector:@selector(imageSignaturesReceivedFromWebServer)])
                 [result.delegate imageSignaturesReceivedFromWebServer]; 
         }else
         {
             result.errorMessage = err; 
             if ([result.delegate respondsToSelector:@selector(imageSignaturesFailedToReceive:)])
                 [result.delegate imageSignaturesFailedToReceive:err]; 
         }
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
//    PictureInfo* p = [picCollection getPictureInfoAtLocation:indx]; 
    
    NSString* hash = [picCollection getPictureInfoAtLocation:indx].info.hash; 
    [webservice sendPageActivityAsync:picCollection.uniqueID pictureHash: hash]; 
}


-(void) dealloc
{
    self.pages = nil; 
    [super dealloc]; 
}



@end
