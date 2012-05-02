//
//  FlickrAccount.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "OAuthProvider.h" 


@interface FlickrAccount: Account <OFFlickrAPIRequestDelegate> 
{    
    //static stuff 
    NSString* _api_key; 
    NSString* _signature; 
 
    
    //dynamic stuff  (the weird thing is that both requestTokena dn accessToken map to context.OAuthToken) so we need to be careful
    //we don't store requestToken as it is temporary. 
    NSString* _requestToken; 
    NSString* _requestSecret; 
    NSString* _accessToken; 
    NSString* _accessSecret; 
    
    OAuthProviderContext* _apiContext; 
    
}


-(void) setApiKey:(NSString*) key andSignature:(NSString*) signature; 

-(BOOL) isActive; 
-(void) activate:(NSString*) username userid:(NSString*) userid accessToken:(NSString*) at accessSecret:(NSString*) as; 


//write access through designated method 
@property (nonatomic, readonly) NSString* api_key; 
@property (nonatomic, readonly) NSString* signature; 

//access methods are provided in pairs 
@property (nonatomic, readonly) NSString* requestToken; 
@property (nonatomic, readonly) NSString* requestSecret; 
@property (nonatomic, readonly) NSString* accessToken; 
@property (nonatomic, readonly) NSString* accessSecret; 
-(void) setRequestToken:(NSString *)requestToken withSecret:(NSString*) requestSecret; 
-(void) setAccessToken:(NSString *)accessToken   withSecret:(NSString*) accessSecret; 

//objective flickr stuff 
@property (nonatomic, retain) OAuthProviderContext* apiContext; 

@end


