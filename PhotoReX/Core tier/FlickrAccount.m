//
//  FlickrAccount.m
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "FlickrAccount.h"
#import "PictureInfo.h"

@implementation FlickrAccount
@synthesize api_key=_api_key; 
@synthesize signature=_signature; 
@synthesize apiContext=_apiContext; 
@synthesize requestToken=_requestToken; 
@synthesize accessToken=_accessToken; 
@synthesize accessSecret=_accessSecret; 


- (id)init
{
    self = [super init];
    if (self) 
    {
        [self loadSettings]; 
    }
    
    return self;
}


-(void) loadSettings
{
    //---------- read the static keys (api_key and signature) 
    NSString* path = [[NSBundle mainBundle] pathForResource:@"AccountSettings" ofType:@"plist"]; 
    NSData* data = [NSData dataWithContentsOfFile:path]; 
    
    NSString* error; 
    NSPropertyListFormat format; 
    NSDictionary* plist; 
    
    plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error]; 
    
    if (plist) 
    {
        NSDictionary* staticSettings = [plist objectForKey:self.accountName]; 
        
        self.api_key = [staticSettings valueForKey:@"api_key"]; 
        self.signature = [staticSettings valueForKey:@"signature"]; 
        
        
        //create the api context 
        
        self.apiContext = [[[OFFlickrAPIContext alloc] initWithAPIKey:self.api_key sharedSecret:self.signature] autorelease]; 
    }
    
    //---------- read user defaults for the frobKey
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* flickr = [ud valueForKey:self.accountName]; 
    
    if (!flickr) 
        return; 
    
    self.requestToken = [flickr objectForKey:@"requestToken"]; 
    self.accessToken = [flickr objectForKey:@"accessToken"]; 
    self.accessSecret = [flickr objectForKey:@"accessSecret"]; 
    
    //the rest is taken care of by the super
    [super loadSettings]; 
    
}


-(void) saveSettings
{    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 

    NSMutableDictionary* flickr = [NSMutableDictionary dictionaryWithCapacity:5]; 
    
    [flickr setValue:self.requestToken forKey:@"requestToken"]; 
    [flickr setValue:self.accessToken forKey:@"accessToken"]; 
    [flickr setValue:self.accessSecret forKey:@"accessSecret"]; 
    
    [ud setValue:flickr forKey:self.accountName]; 
    
    
    //the rest is taken care of by the super 
    [super saveSettings]; 
}


-(NSString*) accountName
{
    return @"flickrAccount" ; 
}


-(BOOL) isActive
{
    BOOL result =  (self.accessToken) && ( [self.accessToken length]); 
    return result; 
}


-(void) deactivate
{
    //TODO: inform server and flickr perhaps? 
    self.apiContext = nil; 
    self.accessToken = nil; 
    self.accessSecret = nil; 
    self.requestToken = nil; 
    
    [self saveSettings]; 
    
}


-(void) dealloc
{
    self.requestToken = nil; 
    self.accessToken = nil; 
    self.accessSecret = nil; 
    self.apiContext = nil; 
    
    [super dealloc]; 
}


@end
