//
//  AccountManager.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrAccount.h"
#import "FiveHundredPXAccount.h"
#import "PictureInfo.h"
#import "Account.h"

//This is a class that keeps track of user accounts in different websites. There's only one instance of this class 
@interface AccountManager : NSObject
{
    NSMutableArray* _accounts;       //list of accounts: this is an array of Account*
}

-(id) init; 
-(FlickrAccount*) flickrAccount;                //WEBSITE: 
-(InstagramAccount*) instagramAccount; 
-(FiveHundredPXAccount*) fiveHundredPXAccount; 


-(BOOL) hasAnyActiveAccount; 
-(Account*) getAccountAtIndex:(int) index; 

+(AccountManager*) standardAccountManager;      //the singleton pattern: we only have one instance of the manager
+(Account*) getAccountFromPictureInfo:(PictureInfo*) pictureInfo;       //retrieves the corresponding account for a pictureInfo

@property (readonly, nonatomic) NSArray* accounts; 
@property (readonly) int NUMBER_OF_ACCOUNTS; 
@end
