//
//  ImageFlickrDataProvider.h
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInfo.h"
#import "ImageDataProvider.h"

#import "ObjectiveFlickr.h" 


//This is a wrapper class that retrieved the actual image data given a pictureInfo from flickr
@interface ImageFlickrDataProvider : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableDictionary* connections; //this is a dictionary from NSURLConnection to observers.
}


-(id) init; 

-(void) getDataForPicture:(PictureInfo*) pictureInfo  withResolution:(ImageResolution) resolution withObserver:(id<DataDownloadObserver>) observer; 

@end
