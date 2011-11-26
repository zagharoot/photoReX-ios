//
//  PictureInfoCollection.h
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInfo.h"


//This class represents a collection of pictureinfo (as retrieved from the webservice)

@interface PictureInfoCollection : NSObject
{
    NSString* _uniqueID;        //? 
    NSArray* _images;           //this is an array of PictureInfo 
    int _count;                 //how many picture inside 
}

@property (retain) NSArray* images; 
@property int count; 
@property (copy) NSString* uniqueID; 


-(void) loadPicturesWithData:(NSArray*) data;               //after the data (which is an array of json data), call this function and the data of each pictureInfo is created/updated from the json data 
-(id) initWithCount:(int) count; 
-(PictureInfo*) getPictureInfoAtLocation:(int) index; 

@end
