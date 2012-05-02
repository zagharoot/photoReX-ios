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

#import "OAuthProvider.h" 


//This is a wrapper class that retrieved the actual image data given a pictureInfo from flickr
@interface ImageFlickrDataProvider : ImageDataProvider <NSURLConnectionDelegate, NSURLConnectionDataDelegate, OAuthRequestDelegate> 
{
    NSMutableDictionary* connections; //this is a dictionary from NSURLConnection to observers.
    
    
    NSMutableDictionary* requests;   //this is a dictionary from OFFFlickrRequests to pictureInfo for outstanding requests waiting for completion 
    
}


-(id) init; 
-(NSString *)urlStringForPhotoWithFlickrInfo:(NSDictionary *)flickrInfo withResolution:(ImageResolution) resolution; 
@end
