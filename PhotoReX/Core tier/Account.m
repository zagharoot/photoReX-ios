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
@synthesize userid=_userid; 
@synthesize enabled=_enabled; 





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
    _userid = [[account objectForKey:@"userid"] copy]; 
    
    if ([account objectForKey:@"enabled"]!=nil)
        _enabled = [[account objectForKey:@"enabled"] boolValue]; 
    else
        _enabled = NO; 
    
}

-(void) saveSettings
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* prevSettings = [ud valueForKey:self.accountName]; 
    NSMutableDictionary* account = [NSMutableDictionary dictionaryWithDictionary:prevSettings]; 
    
    
    NSData *dataObj = UIImageJPEGRepresentation(self.userIconImage, 1.0);
    
    if (dataObj)
        [account setValue:dataObj  forKey:@"userIconImage"]; 
    else
        [account removeObjectForKey:@"userIconImage"]; 
    
    if (self.username)
        [account setValue:self.username  forKey:@"username"]; 
    else
        [account removeObjectForKey:@"username"]; 
    
    if (self.userid)
        [account setValue:self.userid  forKey:@"userid"]; 
    else
        [account removeObjectForKey:@"userid"]; 

    [account setValue:[NSNumber numberWithBool:self.enabled]    forKey:@"enabled"]; 
    
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
    NSString* path = [NSString stringWithFormat:@"%@Icon.png", self.accountName ]; 
//    _iconImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]; 
    
    _iconImage = [[UIImage imageNamed:path] retain];
    
    
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
    self.userid = nil; 
    self.userIconImage = nil; 
//    [self saveSettings]; 
}

-(void) activate
{
    //tell the website
    [[RLWebserviceClient standardClient] registerAccountAsync:[self dictionaryRepresentation]]; 

    //is this the right choice?
    self.enabled = YES; 

}


-(void) setEnabled:(BOOL)enabled
{
    if (_enabled != enabled)
    {
        _enabled = enabled; 
        [[RLWebserviceClient standardClient] setAccountEnabledAsync:self.accountName enabled:_enabled]; 
    }
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





