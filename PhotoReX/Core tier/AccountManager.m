//
//  AccountManager.m
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "AccountManager.h"


static AccountManager* theAccountManager;

@implementation AccountManager

@synthesize accounts = _accounts; 


//perform the singleton pattern
+(AccountManager*) standardAccountManager
{
    if (theAccountManager == nil)
        theAccountManager = [[AccountManager alloc] init]; 

    return theAccountManager;     
}


+(Account*) getAccountFromPictureInfo:(PictureInfo *)pictureInfo
{
    return [[AccountManager standardAccountManager].accounts objectAtIndex:pictureInfo.info.website]; 
}


-(int) NUMBER_OF_ACCOUNTS
{
    return 3; 
    
    //WEBSITE: 
    //todo: can we extract the number of available accounts from the enum? 
}

- (id)init
{
    self = [super init];
    if (self) 
    {
        _accounts = [[NSMutableArray alloc] initWithCapacity:self.NUMBER_OF_ACCOUNTS]; 
        
        //add flickr account 
        FlickrAccount* item = [[[FlickrAccount alloc] init] autorelease]; 
        [_accounts addObject:item]; 
        
        
        //add instagram account 
        InstagramAccount* item2 = [[[InstagramAccount alloc] init] autorelease]; 
        [_accounts addObject:item2]; 
        
        FiveHundredPXAccount* item3 = [[[FiveHundredPXAccount alloc] init] autorelease]; 
        [_accounts addObject:item3]; 
        
        //WEBSITE: 
        
    }
    
    return self;
}

-(BOOL) hasAnyActiveAccount
{
    for (Account* a in self.accounts) {
        if ( [a isActive])
            return YES; 
    }
    
    return NO; 
}


-(void) dealloc
{
    [_accounts release]; 
    [super dealloc]; 
}

-(Account*) getAccountAtIndex:(int)index
{
    //todo: error check! 
    return [self.accounts objectAtIndex:index]; 
}

-(FlickrAccount*) flickrAccount
{
    if ([self.accounts count] > FLICKR_INDEX)
        return [self.accounts objectAtIndex:FLICKR_INDEX]; 
    else
        return nil; 
}

-(InstagramAccount*) instagramAccount
{
    if ([self.accounts count] > INSTAGRAM_INDEX)
        return [self.accounts objectAtIndex:INSTAGRAM_INDEX]; 
    else
        return nil; 
}

-(FiveHundredPXAccount*) fiveHundredPXAccount
{
    if ([self.accounts count] > FIVEHUNDREDPX_INDEX)
        return [self.accounts objectAtIndex:FIVEHUNDREDPX_INDEX]; 
    else
        return nil; 
}

//WEBSITE: 

@end
