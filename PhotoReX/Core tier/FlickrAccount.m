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
@synthesize requestSecret=_requestSecret; 
@synthesize accessToken=_accessToken; 
@synthesize accessSecret=_accessSecret; 


#define kDefaultFlickrRESTAPIEndpoint		@"http://api.flickr.com/services/rest/"
#define kDefaultFlickrAuthEndpoint			@"http://www.flickr.com/services/oauth/"



-(OAuthProviderContext*) apiContext
{
    if (!_apiContext)
    {
        if (self.api_key && self.signature)
            _apiContext = [[OAuthProviderContext alloc] initWithAPIKey:self.api_key sharedSecret:self.signature authEndPoint:kDefaultFlickrAuthEndpoint restEndPoint:kDefaultFlickrRESTAPIEndpoint]; 
    }
    
    return _apiContext; 
}

-(void) setApiKey:(NSString *)key andSignature:(NSString *)signature
{
    [_api_key release]; 
    [_signature release]; 

    _api_key = [key copy]; 
    _signature = [signature copy]; 
    
    //update the context 
    self.apiContext = [[[OAuthProviderContext alloc] initWithAPIKey:self.api_key sharedSecret:self.signature authEndPoint:kDefaultFlickrAuthEndpoint restEndPoint:kDefaultFlickrRESTAPIEndpoint] autorelease];
}

-(void) setRequestToken:(NSString *)requestToken withSecret:(NSString *)requestSecret
{
    [_requestToken release];  _requestToken = nil; 
    [_requestSecret release]; _requestSecret = nil; 

    _requestToken = [requestToken copy]; 
    _requestSecret = [requestSecret copy]; 
    
    self.apiContext.OAuthToken = _requestToken; 
    self.apiContext.OAuthTokenSecret = _requestSecret; 
        
}

-(void) setAccessToken:(NSString *)accessToken withSecret:(NSString *)accessSecret
{
    [_accessToken release]; _accessToken = nil; 
    [_accessSecret release]; _accessSecret = nil; 

    _accessToken = [accessToken copy]; 
    _accessSecret = [accessSecret copy]; 
    
    //dont need the requestToken any more as it was temporary
    if (accessToken)
    {
        [_requestToken release];  _requestToken = nil; 
        [_requestSecret release]; _requestSecret = nil; 
    }
    
    self.apiContext.OAuthToken = _accessToken; 
    self.apiContext.OAuthTokenSecret = _accessSecret; 
}


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
        
        [self setApiKey:[staticSettings valueForKey:@"api_key"] andSignature:[staticSettings valueForKey:@"signature"]]; 
    }
    
    //---------- read user defaults for the frobKey
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* flickr = [ud valueForKey:self.accountName]; 
    
    if (!flickr) 
        return; 
    
    //remember we don't store the requestToken, just the accessTOken
    [self setAccessToken:[flickr objectForKey:@"accessToken"] withSecret:[flickr objectForKey:@"accessSecret"]]; 

    //the rest is taken care of by the super
    [super loadSettings]; 
    
}


-(void) saveSettings
{    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* prevSettings = [ud valueForKey:self.accountName]; 

    NSMutableDictionary* flickr = [NSMutableDictionary dictionaryWithDictionary:prevSettings]; 
    
    if (self.accessToken)     
        [flickr setValue:self.accessToken forKey:@"accessToken"]; 
    else 
        [flickr removeObjectForKey:@"accessToken"]; 
    
    if (self.accessSecret)
        [flickr setValue:self.accessSecret  forKey:@"accessSecret"]; 
    else
        [flickr removeObjectForKey:@"accessSecret"]; 
    
    [ud setValue:flickr forKey:self.accountName]; 
    
    
    //the rest is taken care of by the super 
    [super saveSettings]; 
}


-(NSString*) accountName
{
    return @"flickrAccount" ; 
}


-(NSDictionary*) dictionaryRepresentation
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];  
    
    [result setValue:self.accountName?self.accountName:[NSNull null] forKey:@"accountName"]; 
    [result setValue:self.requestToken?self.requestToken:[NSNull null]  forKey:@"requestToken"]; 
    [result setValue:self.requestSecret?self.requestSecret:[NSNull null]  forKey:@"requestSecret"]; 
    [result setValue:self.accessToken?self.accessToken:[NSNull null]  forKey:@"accessToken"]; 
    [result setValue:self.accessSecret?self.accessSecret:[NSNull null]  forKey:@"accessSecret"]; 
    
    
    return result; 
}

-(BOOL) isActive
{
    BOOL result =  (self.accessToken) && ( [self.accessToken length]); 
    return result; 
}

-(void) activate:(NSString *)username userid:(NSString*) userid accessToken:(id)at accessSecret:(NSString *)as
{
    self.username = username; 
    self.userid = userid; 
    [self setAccessToken:at withSecret:as]; 
    
    [super activate];       //this should be called last 
    [self saveSettings]; 
}

-(void) deactivate
{    
    [super deactivate];     //this should be called first 

    [self setAccessToken:nil withSecret:nil]; 
    [self setRequestToken:nil withSecret:nil]; 
    self.apiContext = nil; 
    
    [self saveSettings]; 
}

-(BOOL) supportsFavorite
{
    return YES; 
}

-(void) dealloc
{
    
    [self setAccessToken:nil withSecret:nil]; 
    [self setRequestToken:nil withSecret:nil]; 
    self.apiContext = nil; 
    
    [super dealloc]; 
}


-(void) setUserid:(NSString *)userid
{
    [_userid release]; 
    _userid =[userid copy]; 

    if (userid) 
    {
        NSString* url = [NSString stringWithFormat:@"http://flickr.com/buddyicons/%@.jpg", userid ]; 
        NSData* iconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMapped error:nil]; 
        self.userIconImage = [UIImage imageWithData:iconData];
    }else {
        self.userIconImage = nil; 
    }
    [self saveSettings]; 
}
@end
