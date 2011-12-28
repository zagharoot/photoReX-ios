//
//  ImageFlickrDataProvider.h
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInfo.h"
#import "ImageDataProviderManager.h"

#import "ObjectiveFlickr.h" 


//This is a wrapper class that retrieved the actual image data given a pictureInfo from flickr
@interface ImageFlickrDataProvider : ImageDataProvider <NSURLConnectionDelegate, NSURLConnectionDataDelegate, OFFlickrAPIRequestDelegate> 
{
    NSMutableDictionary* connections; //this is a dictionary from NSURLConnection to observers.
    
    
    NSMutableDictionary* detailRequests;   //this is a dictionary from OFFFlickrRequests to pictureInfo for outstanding connections 
    
    NSMutableDictionary* favoriteRequest; //this is a dictionary from OFFlickrRequests to pictureInfo for outstanding connections 
    
}


-(id) init; 
-(NSString *)urlStringForPhotoWithFlickrInfo:(NSDictionary *)flickrInfo withResolution:(ImageResolution) resolution; 
@end
