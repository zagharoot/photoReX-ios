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
#define SERVER_ADDRESS   @"http://68.45.157.225/rlimage/imagerecommendationservice.asmx/recommend"


// This class takes care of receiving information from our own web server (image recommendations). 
// 

@interface RLWebserviceClient : NSObject
{
    NSMutableURLRequest* _request; 
    NSString* _userid; 
}


-(id) initWithUserid:(NSString*) u; 
//picInfoData is actually an array of json data that can be used to generated pictureInfos
-(void) getPageFromServerAsync:(int) howMany andRunBlock:(void (^)(NSString* pageid, NSArray* picInfoData)) theBlock ; 

//sends user activity to the server (guarantees receive on the server side) 
-(void) sendPageActivity:(NSString*) pageid pictureIndex:(int) index; 

@property (retain, readonly) NSMutableURLRequest* request; 
@property (copy) NSString* userid; 

@end
