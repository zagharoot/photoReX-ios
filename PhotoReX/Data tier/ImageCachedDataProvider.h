//
//  ImageCachedDataProvider.h
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInfo.h"

@interface ImageCachedDataProvider : NSObject

-(NSData*) getDataForPicture:(PictureInfo*) pictureInfo   withResolution:(ImageResolution) resolution;

//cache the data for the picture 
-(void) storeDataForPicture:(PictureInfo*) pictureInfo andImage:(UIImage*) data andResolution:(ImageResolution) resolution;  
@end
