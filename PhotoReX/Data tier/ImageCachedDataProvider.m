//
//  ImageCachedDataProvider.m
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "ImageCachedDataProvider.h"

@implementation ImageCachedDataProvider

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(NSData*) getDataForPicture:(PictureInfo *)pictureInfo   withResolution:(ImageResolution) resolution
{
    //TODO: write the implementation
    return nil; 
    
}



-(void) storeDataForPicture:(PictureInfo *)pictureInfo andImage:(UIImage*) data andResolution:(ImageResolution)resolution
{
    //store the data somewhere
    
}


@end
