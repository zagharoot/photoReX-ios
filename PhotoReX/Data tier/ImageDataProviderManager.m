//
//  DataProvider.m
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "ImageDataProviderManager.h"
#import "ImageFlickrDataProvider.h"
#import "ImageInstagramDataProvider.h"
#import "ImageFiveHundredPXDataProvider.h"
//WEBSITE: 

static ImageDataProviderManager* theProvider=nil; 


@implementation ImageDataProvider 

-(BOOL) setFavorite:(BOOL)fav forPictureInfo:(PictureInfo *)pictureInfo
{
    return NO; 
}

@end


@implementation ImageDataProviderManager

@synthesize cachedProvider = _cachedProvider; 
@synthesize flickrProvider = _flickrProvider; 
@synthesize instagramProvider = _instagramProvider; 
@synthesize fiveHundredPXProvider=_fiveHundredPXDataProvider; 
//WEBSITE: 

+(ImageDataProviderManager*) mainDataProvider
{
    if (theProvider==nil)
        theProvider = [[ImageDataProviderManager alloc] init]; 

    return theProvider; 
}


- (id)init
{
    self = [super init];

    if (self) {
        // Initialization code here.
        _flickrProvider = [[ImageFlickrDataProvider alloc] init]; 
        _instagramProvider = [[ImageInstagramDataProvider alloc] init]; 
        _fiveHundredPXDataProvider = [[ImageFiveHundredPXDataProvider alloc] init]; 
        //WEBSITE: 
        
    }
    
    return self;
}


-(ImageDataProvider*) dataProviderForPictureInfo:(PictureInfo *)pictureInfo
{
    switch (pictureInfo.info.website) {
        case FLICKR_INDEX:
            return self.flickrProvider; 
        case INSTAGRAM_INDEX:
            return self.instagramProvider; 
        case FIVEHUNDREDPX_INDEX:
            return self.fiveHundredPXProvider; 
        default:
            return nil; 
    }
    //WEBSITE: 

}


-(void) fillInDetailForPictureInfo:(PictureInfo*) pictureInfo
{
    [[self dataProviderForPictureInfo:pictureInfo] fillInDetailForPictureInfo:pictureInfo]; 
}

-(BOOL) setFavorite:(BOOL)fav forPictureInfo:(PictureInfo *)pictureInfo
{
    return [[self dataProviderForPictureInfo:pictureInfo] setFavorite:fav forPictureInfo:pictureInfo]; 
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
    
    
    [[self dataProviderForPictureInfo:pictureInfo] getDataForPicture:pictureInfo withResolution:resolution withObserver:observer]; 
}

-(void) addImageToCache:(UIImage *)img forPictureInfo:(PictureInfo *)pictureInfo andResolution:(ImageResolution)resolution
{
    [self.cachedProvider storeDataForPicture:pictureInfo andImage:img andResolution:resolution]; 
}


-(void) dealloc
{
    [_flickrProvider release]; 
    [_instagramProvider release]; 
    [_fiveHundredPXDataProvider release]; 
    //WEBSITE: 
    
    [super dealloc]; 
}


@end
