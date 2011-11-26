//
//  DataProvider.m
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "ImageDataProvider.h"
#import "ImageFlickrDataProvider.h"
#import "ImageInstagramDataProvider.h"
//WEBSITE: 


static ImageDataProvider* theProvider=nil; 

@implementation ImageDataProvider

@synthesize cachedProvider = _cachedProvider; 
@synthesize flickrProvider = _flickrProvider; 
@synthesize instagramProvider = _instagramProvider; 
//WEBSITE: 

+(ImageDataProvider*) mainDataProvider
{
    if (theProvider==nil)
        theProvider = [[ImageDataProvider alloc] init]; 

    return theProvider; 
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _flickrProvider = [[ImageFlickrDataProvider alloc] init]; 
        _instagramProvider = [[ImageInstagramDataProvider alloc] init]; 
        //WEBSITE: 
        
    }
    
    return self;
}


-(void) getDataForPicture:(PictureInfo *)pictureInfo  withResolution:(ImageResolution) resolution withObserver:(id<DataDownloadObserver>)observer
{
    NSData* result; 
    
    //already in cache    
    if ( (result= [self.cachedProvider getDataForPicture:pictureInfo withResolution:resolution]))
    {
        UIImage* img = [UIImage imageWithData:result]; 
        [observer imageDidBecomeAvailable:img]; 
        return; 
    }
    
    if (pictureInfo.info.website == FLICKR_INDEX)
    {
        [self.flickrProvider getDataForPicture:pictureInfo withResolution:resolution withObserver:observer]; 
        return; 
    }
    
    
    if (pictureInfo.info.website == INSTAGRAM_INDEX)
    {
        [self.instagramProvider getDataForPicture:pictureInfo withResolution:resolution withObserver:observer];
        return; 
    }
    
        //WEBSITE: add code for other websites

}

-(void) addImageToCache:(UIImage *)img forPictureInfo:(PictureInfo *)pictureInfo andResolution:(ImageResolution)resolution
{
    [self.cachedProvider storeDataForPicture:pictureInfo andImage:img andResolution:resolution]; 
}


-(void) dealloc
{
    [_flickrProvider release]; 
    [_instagramProvider release]; 
    //WEBSITE: 
    
    [super dealloc]; 
}


@end
