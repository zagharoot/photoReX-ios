//
//  RLWebserviceClient.h
//  rlimage
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJsonParser.h"


// This class takes care of receiving information from our own web server (image recommendations). 
// 



enum WebServiceLocation {
    RLWEBSERVICE_LAPTOP = 0,
    RLWEBSERVICE_MAC = 1, 
    RLWEBSERVICE_AMAZON = 2
    };

@interface RLWebserviceClient : NSObject
{
    NSMutableURLRequest* _requestRecommend;
    NSMutableURLRequest* _requestImageViewed; 
    
    NSString* _userid; 
    NSString* _signature; 
    enum WebServiceLocation _webServiceLocation; 
}

-(void) setWebServiceLocation:(enum WebServiceLocation) location; 
+(RLWebserviceClient*) standardClient;      //returns the onl object we hve for this class 

-(void) registerAsNewAccount; 
-(void) loadSettings; 
-(void) saveSettings; 

//picInfoData is actually an array of json data that can be used to generated pictureInfos
-(void) getPageFromServerAsync:(int) howMany andRunBlock:(void (^)(NSString* pageid, NSArray* picInfoData, NSError* err)) theBlock ; 

//sends user activity to the server (guarantees receive on the server side) 
-(void) sendPageActivityAsync:(NSString*) pageid pictureHash:(NSString*) hash; 

-(void) registerAccountAsync:(NSDictionary*) account;            //given a dictionary representation of an account, registers it with the website 
-(void) deregsiterAccountAsync:(NSDictionary*) account; 
-(void) setAccountEnabledAsync:(NSString*) accountName enabled:(BOOL) enabled; 

@property (retain, readonly) NSMutableURLRequest* requestRecommend;
@property (retain, readonly) NSMutableURLRequest* requestImageViewed; 
@property (nonatomic, copy) NSString* userid; 
@property (nonatomic, copy) NSString* signature; 
@property (nonatomic) enum WebServiceLocation webServiceLocation; 

@end
