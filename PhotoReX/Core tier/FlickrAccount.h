//
//  FlickrAccount.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface FlickrAccount: Account
{
    NSString* _frobKey; 
    
    //static stuff 
    NSString* _api_key; 
    NSString* _signature; 
}



-(BOOL) isActive; 


@property (copy, nonatomic) NSString* frobKey; 

@property (nonatomic, copy) NSString* api_key; 
@property (nonatomic, copy) NSString* signature; 

@end
