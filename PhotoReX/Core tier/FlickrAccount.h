//
//  FlickrAccount.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "ObjectiveFlickr.h" 


@interface FlickrAccount: Account <OFFlickrAPIRequestDelegate> 
{    
    //static stuff 
    NSString* _api_key; 
    NSString* _signature; 
 
    
    //dynamic stuff 
    NSString* _requestToken; 
    NSString* _requestSecret; 
    NSString* _accessToken; 
    NSString* _accessSecret; 
    
    OFFlickrAPIContext* _apiContext; 
    
    //personal stuff 
    OFFlickrAPIRequest* _apiRequest;        //used to obtain nsid from username 
}


-(void) setApiKey:(NSString*) key andSignature:(NSString*) signature; 

-(BOOL) isActive; 

//write access through designated method 
@property (nonatomic, readonly) NSString* api_key; 
@property (nonatomic, readonly) NSString* signature; 

@property (nonatomic, copy) NSString* requestToken; 
@property (nonatomic, copy) NSString* requestSecret; 
@property (nonatomic, copy) NSString* accessToken; 
@property (nonatomic, copy) NSString* accessSecret; 

//objective flickr stuff 
@property (nonatomic, retain) OFFlickrAPIContext* apiContext; 
@property (nonatomic, retain) OFFlickrAPIRequest* apiRequest; 

@end


