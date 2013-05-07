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
//    NSArray *documentDirectories =
//    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                        NSUserDomainMask, YES);
    
//    documentDirectories = NSSearchPathForDirectoriesInDomains(NS, NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
//    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    
    sleep(1);
    
    
    NSString* path = @"/var/mobile/Applications/37057898-D84A-4793-9E92-7519F04B5901/photoRex.app/zara.jpg"; //[documentDirectory stringByAppendingPathComponent:@"zara.jpg"];
    
    NSData* data = [NSData dataWithContentsOfFile: path]; 
    return data;
    //TODO: write the implementation
    return nil; 
    
}



-(void) storeDataForPicture:(PictureInfo *)pictureInfo andImage:(UIImage*) data andResolution:(ImageResolution)resolution
{
    //store the data somewhere
    
}


@end
