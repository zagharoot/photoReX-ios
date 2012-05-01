//
//  DataProvider.h
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInfo.h"
#import "ImageCachedDataProvider.h"

@protocol DataDownloadObserver <NSObject>
@optional
-(void) imageDidBecomeAvailable:(UIImage*) img; 
-(void) imageFailedToLoad:(NSString*) reason; 
-(void) percentDataBecameAvailable:(double) percentage; 
-(void) didGetUserDetails:(NSDictionary*) result; 
//-(void) didGetCommentsForImage; 
-(void) operationFailed:(id) operation withError:(NSError*) err; 
@end

@class ImageFlickrDataProvider; 
@class ImageInstagramDataProvider; 
@class ImageFiveHundredPXDataProvider; 
//WEBSITE: 


// An abstract class for providing data for each service
@interface ImageDataProvider  : NSObject
-(void) getDataForPicture:(PictureInfo*) pictureInfo  withResolution:(ImageResolution) resolution withObserver:(id<DataDownloadObserver>) observer; 

-(void) fillInDetailForPictureInfo:(PictureInfo*) pictureInfo; 
-(BOOL) setFavorite:(BOOL) fav forPictureInfo:(PictureInfo*) pictureInfo; 
-(void) getUserInfoForObserver: (id<DataDownloadObserver>) observer;            //retrieves the current authenticated user info 

@end


// This class contains information about one download of an image 
@interface ImageDataConnectionDetails : NSObject {
    id<DataDownloadObserver> observer; 
    long totalBytes; 
    long receivedBytes; 
    NSMutableData* data; 
}

-(id) initWithObserver:(id<DataDownloadObserver>) obs; 

@property long totalBytes; 
@property long receivedBytes; 
@property (retain) id<DataDownloadObserver> observer; 
@property (assign) NSMutableData* data; 

@end



//This is a wrapper class that contains different providers that actually retrieve data in different ways. 
//Given a pictureInfo, it automatically discovers what data provider to use to retrieve the data
@interface ImageDataProviderManager : NSObject
{
    ImageCachedDataProvider* _cachedProvider; 
    ImageFlickrDataProvider* _flickrProvider; 
    ImageInstagramDataProvider* _instagramProvider; 
    ImageFiveHundredPXDataProvider* _fiveHundredPXDataProvider; 
    //WEBSITE: 
}

@property (retain) ImageCachedDataProvider* cachedProvider;
@property (retain) ImageFlickrDataProvider* flickrProvider; 
@property (retain) ImageInstagramDataProvider* instagramProvider; 
@property (retain) ImageFiveHundredPXDataProvider* fiveHundredPXProvider; 
//WEBSITE: 

+(ImageDataProviderManager*) mainDataProvider; 

-(ImageDataProvider*) dataProviderForPictureInfo:(PictureInfo*) pictureInfo; 


-(void) getDataForPicture:(PictureInfo*) pictureInfo withResolution:(ImageResolution) resolution withObserver:(id<DataDownloadObserver>) observer;   //automatically discover what provider to use to get the data, and then use it to retrieve the data. This call is blocking

-(void) fillInDetailForPictureInfo:(PictureInfo*) pictureInfo; //given a pictureInfo, automatically gets the details of the picture from the corresponding website 



-(BOOL) setFavorite:(BOOL) fav forPictureInfo:(PictureInfo*) pictureInfo;  

-(void) addImageToCache:(UIImage*) img forPictureInfo:(PictureInfo*) pictureInfo andResolution:(ImageResolution) resolution; 


@end
