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


@interface FlickrAccount: Account
{    
    //static stuff 
    NSString* _api_key; 
    NSString* _signature; 
 
    
    //dynamic stuff 
    NSString* _requestToken; 
    NSString* _accessToken; 
    NSString* _accessSecret; 
    
    OFFlickrAPIContext* _apiContext; 
}



-(BOOL) isActive; 


@property (nonatomic, copy) NSString* api_key; 
@property (nonatomic, copy) NSString* signature; 

@property (nonatomic, copy) NSString* requestToken; 
@property (nonatomic, copy) NSString* accessToken; 
@property (nonatomic, copy) NSString* accessSecret; 

//objective flickr stuff 
@property (nonatomic, retain) OFFlickrAPIContext* apiContext; 
@end
