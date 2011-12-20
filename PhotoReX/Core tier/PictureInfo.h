//
//  PictureInfo.h
//  rlimage
//
//  Created by Ali Nouri on 7/23/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum ImageResolution
{
    ImageResolutionGridThumbnail =1, 
    ImageResolutionFullPage=2
} ImageResolution;



typedef enum ImageActivityStatus
{
    ImageActivityStatusUnknown =-1,
    ImageActivityStatusNotVisited=0, 
    ImageActivityStatusVisited = 1, 
    ImageActivityStatusDisliked = 2
} ImageActivityStatus;


enum ACCOUNT_INDEX  //WEBSITE: add the website here 
{
    NOT_AVAILABLE = -1, 
    FLICKR_INDEX = 0, 
    INSTAGRAM_INDEX = 1, 
    FIVEHUNDREDPX_INDEX = 2,
    GOOGLE_INDEX = 3
};



//This class provides an abstract picture detail information. Depending on the provider, different 
//information should be kept. 
@interface PictureInfoDetails : NSObject {
    enum ACCOUNT_INDEX _website; 
}
-(NSDictionary*) getDictionaryRepresentation; 
@property enum ACCOUNT_INDEX website; 
@end //-----------------------------------



@class PictureInfo; 

/*
//anybody who's working with pictureinfo should implement this 
@protocol PictureInfoDelegate <NSObject>
@optional
-(void) imageDataDidChange;             //this function is called each time the data of the object is changed
-(void) imageActivityStatusDidChange:(PictureInfo*) pictureInfo newStatus:(ImageActivityStatus) status;          //this function is called each time the userActivityStatus changes
@end //---------------------------------

*/



//This class provides a representation of a picture object  
@interface PictureInfo : NSObject
{
    PictureInfoDetails* _info; 
    NSDictionary* _dictionaryRepresentation; 
    
    ImageActivityStatus _userActivityStatus; 
}

+(ImageResolution) CGSizeToImageResolution:(CGSize) size; 

-(BOOL) isInfoDataAvailable;                                    //is the actual picture data available?
-(void) createInfoFromJsonData:(NSDictionary*) data; 

-(void) visit; 


@property (nonatomic, retain) PictureInfoDetails* info; 
@property (readonly) NSDictionary* dictionaryRepresentation; 
@property (nonatomic) ImageActivityStatus userActivityStatus; 

@end





//The picture detail information for FLICKR 
@interface FlickrPictureInfo : PictureInfoDetails {
@private
    NSString* _picID; 
    NSString* _server; 
    NSString* _farm; 
    NSString* _secret; 
}


-(id) initWithID:(NSString*) id andServer:(NSString*) server andFarm:(NSString*) farm andSecret:(NSString*) secret;

+(FlickrPictureInfo*) infoFromJsonData:(NSDictionary*) data; 

@property (readonly, copy) NSString* picID; 
@property (readonly, copy) NSString* server; 
@property (readonly, copy) NSString* farm; 
@property (readonly, copy) NSString* secret; 


@end



@interface InstagramPictureInfo : PictureInfoDetails {
@private
    
}

+(InstagramPictureInfo*) infoFromJsonData:(NSDictionary*) data; 

@end



@interface FiveHundredPXPictureInfo : PictureInfoDetails {
@private
    
}

+(FiveHundredPXPictureInfo*) infoFromJsonData:(NSDictionary*) data; 
@end


//WEBSITE: create the website picture info here 




