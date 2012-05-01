//
//  FifeHundredPXAccount.h
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "Account.h"
#import "ObjectiveFlickr.h" 
#import "ImageDataProviderManager.h" 

@interface FiveHundredPXAccount : Account <DataDownloadObserver>
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
    
}

-(void) setApiKey:(NSString*) key andSignature:(NSString*) signature; 

//this activates the account and retrieves the user information from the website based on tokens, it then broadcasts the result so observers can adopt
-(void) activateWithAccessToken:(NSString*) at accessSecret:(NSString*) ats; 

//write access through designated method 
@property (nonatomic, readonly) NSString* api_key; 
@property (nonatomic, readonly) NSString* signature; 

@property (nonatomic, copy) NSString* requestToken; 
@property (nonatomic, copy) NSString* requestSecret; 
@property (nonatomic, copy) NSString* accessToken; 
@property (nonatomic, copy) NSString* accessSecret; 


-(void) setRequestToken:(NSString *)requestToken withSecret:(NSString*) requestSecret; 
-(void) setAccessToken:(NSString *)accessToken   withSecret:(NSString*) accessSecret; 

//objective flickr stuff 
@property (nonatomic, retain) OFFlickrAPIContext* apiContext; 


@end
