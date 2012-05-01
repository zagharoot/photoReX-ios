//
//  ImageFiveHundredPXDataProvider.h
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInfo.h"
#import "ImageDataProviderManager.h"

#import "ObjectiveFlickr.h" 

@interface ImageFiveHundredPXDataProvider : ImageDataProvider <NSURLConnectionDelegate, NSURLConnectionDataDelegate, OFFlickrAPIRequestDelegate> 

{
    NSMutableDictionary* connections; //this is a dictionary from NSURLConnection to observers.
    
    
    NSMutableDictionary* requests;   //this is a dictionary from OFFFlickrRequests to pictureInfo for outstanding requests waiting for completion 
    
}



-(id) init; 
-(NSString *)urlStringForPhotoWithInfo:(NSDictionary *)info withResolution:(ImageResolution) resolution; 
-(void) getCurrentUserInfoAndRunBlock:(void (^)(NSError* err, NSDictionary* params)) theBlock ;


@end
