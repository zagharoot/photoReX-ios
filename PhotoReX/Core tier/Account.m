//
//  Account.m
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "Account.h"
#import "RLWebserviceClient.h" 
#import "PictureInfo.h" 


@implementation Account
@synthesize userIconImage=_userIconImage; 
@synthesize username=_username; 

-(void) loadSettings
{
    //---------- read user defaults for the frobKey
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* account = [ud valueForKey:self.accountName]; 
    
    if (!account) 
        return; 
    
    NSData* iconData =  [account objectForKey:@"userIconImage"]; 
    if (iconData)
        _userIconImage = [[UIImage imageWithData:iconData] retain];     

    
    _username = [[account objectForKey:@"username"] copy]; 
}

-(void) saveSettings
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* prevSettings = [ud valueForKey:self.accountName]; 
    NSMutableDictionary* account = [NSMutableDictionary dictionaryWithDictionary:prevSettings]; 
    
    
    NSData *dataObj = UIImageJPEGRepresentation(self.userIconImage, 1.0);
    [account setValue:dataObj?dataObj:[NSNull null]  forKey:@"userIconImage"]; 
    
    [account setValue:self.username?self.username:[NSNull null]  forKey:@"username"]; 
    
    [ud setValue:account?account:[NSNull null]  forKey:self.accountName]; 
    
    [self broadcastChange]; 
}


-(UIImage*) logoImage
{
    if (_logoImage != nil)
        return _logoImage; 
        
    
    //first time use, create it: 
    NSString* path = [NSString stringWithFormat:@"%@TableCell", self.accountName ]; 
    _logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]; 
    
    return _logoImage; 
}

-(UIImage*) iconImage
{
    if (_iconImage != nil)
        return _iconImage; 
    
    
    //first time use, create it: 
    NSString* path = [NSString stringWithFormat:@"%@Icon", self.accountName ]; 
    _iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]; 
    
    return _iconImage; 
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


-(void) didReceiveMemoryWarning
{
    _logoImage = nil;       //we can lazily recreate this later! 
}


-(BOOL) supportsFavorite
{
    return NO; 
}

-(NSString*) accountName
{
    return @"No Account"; 
}

-(NSDictionary*) dictionaryRepresentation
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:8]; 
    [result setValue:self.username?self.username:[NSNull null]  forKey:@"username"]; 
    return result; 
}

-(void) deactivate
{
    //tell the website 
    [[RLWebserviceClient standardClient] deregsiterAccountAsync:[self dictionaryRepresentation]]; 
    
    self.username = nil; 
    self.userIconImage = nil; 
    [self saveSettings]; 
}

-(void) activate
{
    //tell the website
    [[RLWebserviceClient standardClient] registerAccountAsync:[self dictionaryRepresentation]]; 
}

-(void) broadcastChange
{
    //publish this to the notification center 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountDetailsDidChange" object:self]; 
}


-(BOOL) isActive
{
    return NO; 
}


-(void) dealloc
{
    self.username = nil; 
    self.userIconImage = nil; 
    
    [super dealloc]; 
}


@end



@implementation InstagramAccount


-(NSString*) accountName
{
    return @"instagram"; 
}


-(BOOL) isActive
{
    return NO; 
}



@end





