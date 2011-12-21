//
//  RLWebserviceClient.h
//  rlimage
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJsonParser.h"

//#define SERVER_ADDRESS   @"http://192.168.10.106/rlimage/imagerecommendationservice.asmx/recommend"
#define SERVER_ADDRESS   @"http://68.45.157.225"

#define SERVICE_RECOMMEND   @"/rlimage/imagerecommendationservice.asmx/recommend" 
#define SERVICE_IMAGEVIEWED     @"/rlimage/imagerecommendationservice.asmx/updateModel"
#define SERVICE_REGISTER_ACCOUNT  @"/rlimage/imagerecommendationservice.asmx/registerAccount"
#define SERVICE_DEREGISTER_ACCOUNT  @"/rlimage/imagerecommendationservice.asmx/deregisterAccount"
#define SERVICE_CREATE_USER         @"/rlimage/imagerecommendationservice.asmx/createUser"

// This class takes care of receiving information from our own web server (image recommendations). 
// 

@interface RLWebserviceClient : NSObject
{
    NSMutableURLRequest* _requestRecommend;
    NSMutableURLRequest* _requestImageViewed; 
    
    NSString* _userid; 
}


+(RLWebserviceClient*) standardClient;      //returns the onl object we hve for this class 

-(void) registerAsNewAccount; 
-(void) loadUserid; 


//picInfoData is actually an array of json data that can be used to generated pictureInfos
-(void) getPageFromServerAsync:(int) howMany andRunBlock:(void (^)(NSString* pageid, NSArray* picInfoData)) theBlock ; 

//sends user activity to the server (guarantees receive on the server side) 
-(void) sendPageActivityAsync:(NSString*) pageid pictureIndex:(int) index; 

-(void) registerAccountAsync:(NSDictionary*) account;            //given a dictionary representation of an account, registers it with the website 
-(void) deregsiterAccountAsync:(NSDictionary*) account; 


@property (retain, readonly) NSMutableURLRequest* requestRecommend;
@property (retain, readonly) NSMutableURLRequest* requestImageViewed; 
@property (nonatomic, copy) NSString* userid; 

@end
