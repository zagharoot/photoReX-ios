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
    ImageActivityStatusViewed = 1, 
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
    NSString* _hash; 
    
    NSString* _author; 
    NSString* _title; 
    NSString* _subtitle; 

    BOOL _isFavorite; 
}
-(NSDictionary*) getDictionaryRepresentation; 
@property enum ACCOUNT_INDEX website; 

@property (nonatomic, copy) NSString* author; 
@property (nonatomic, copy) NSString* title; 
@property (nonatomic, copy) NSString* subtitle; 
@property (nonatomic) BOOL isFavorite; 
@property (nonatomic, readonly) NSString* hash; 

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

-(void) makeViewed; 


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
    
    
    //image related stuff 
    int _numberOfVisits;
    int _numberOfComments; 
}


-(id) initWithID:(NSString*) id andServer:(NSString*) server andFarm:(NSString*) farm andSecret:(NSString*) secret andHash:(NSString*) hash;

+(FlickrPictureInfo*) infoFromJsonData:(NSDictionary*) data; 

@property (readonly, copy) NSString* picID; 
@property (readonly, copy) NSString* server; 
@property (readonly, copy) NSString* farm; 
@property (readonly, copy) NSString* secret; 


@property (nonatomic) int numberOfVisits; 
@property (nonatomic) int numberOfComments; 


@end



@interface InstagramPictureInfo : PictureInfoDetails {
@private
    
}

+(InstagramPictureInfo*) infoFromJsonData:(NSDictionary*) data; 

@end



@interface FiveHundredPXPictureInfo : PictureInfoDetails {
@private
    
    NSString* _picID; 
    NSString* _baseURL; 

    
    //image related stuff 
    int _numberOfVisits;
    int _numberOfComments; 
    
}

@property (readonly, copy) NSString* picID; 

@property (nonatomic) int numberOfVisits; 
@property (nonatomic) int numberOfComments; 
@property (readonly, copy) NSString* baseURL; 


+(FiveHundredPXPictureInfo*) infoFromJsonData:(NSDictionary*) data; 
-(id) initWithID:(NSString*) ID andBaseURL:(NSString*) bu andHash:(NSString*) hash;

@end


//WEBSITE: create the website picture info here 




