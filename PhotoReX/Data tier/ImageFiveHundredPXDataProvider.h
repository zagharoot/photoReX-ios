//
//  ImageFiveHundredPXDataProvider.h
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "ImageDataProviderManager.h"

@interface ImageFiveHundredPXDataProvider : ImageDataProvider <NSURLConnectionDelegate, NSURLConnectionDataDelegate> 

{
    NSMutableDictionary* connections; //this is a dictionary from NSURLConnection to observers.
    
    
    NSMutableDictionary* requests;   //this is a dictionary from OFFFlickrRequests to pictureInfo for outstanding requests waiting for completion 
    
}



-(id) init; 
-(NSString *)urlStringForPhotoWithInfo:(NSDictionary *)info withResolution:(ImageResolution) resolution; 
@end
