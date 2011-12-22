//
//  FifeHundredPXAccount.h
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "Account.h"

@interface FiveHundredPXAccount : Account
{
    //static stuff 
    NSString* _api_key; 
    NSString* _signature; 
    
    //dynamic stuff 
    NSString* _requestToken; 
    NSString* _requestSecret; 
    NSString* _accessToken; 
    NSString* _accessSecret; 
    
}

-(void) setApiKey:(NSString*) key andSignature:(NSString*) signature; 
-(void) activate:(NSString*) username accessToken:(NSString*) at accessSecret:(NSString*) as; 


//write access through designated method 
@property (nonatomic, readonly) NSString* api_key; 
@property (nonatomic, readonly) NSString* signature; 

@property (nonatomic, copy) NSString* requestToken; 
@property (nonatomic, copy) NSString* requestSecret; 
@property (nonatomic, copy) NSString* accessToken; 
@property (nonatomic, copy) NSString* accessSecret; 

@end
