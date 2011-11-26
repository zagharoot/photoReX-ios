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
}



-(BOOL) isActive; 


//todo: change this to atomic (do we need atomicity?)
@property (copy, nonatomic) NSString* frobKey; 

@end
