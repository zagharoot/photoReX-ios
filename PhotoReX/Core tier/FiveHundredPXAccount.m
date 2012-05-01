//
//  FifeHundredPXAccount.m
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "FiveHundredPXAccount.h"
#import "PictureInfo.h"
#import "ImageDataProviderManager.h"
#import "ImageFiveHundredPXDataProvider.h"

@implementation FiveHundredPXAccount
@synthesize api_key=_api_key; 
@synthesize signature=_signature; 
@synthesize requestToken=_requestToken; 
@synthesize requestSecret=_requestSecret; 
@synthesize accessToken=_accessToken; 
@synthesize accessSecret=_accessSecret; 
@synthesize apiContext=_apiContext; 


#define k500PXAuthEndPoint			@"https://api.500px.com/v1/oauth/"
#define k500PXRESTEndPoint          @"https://api.500px.com/v1/"

-(UIImage*) logoImage
{
    if (_logoImage != nil)
        return _logoImage; 
    
    
    //first time use, create it: 
    NSString* path = [NSString stringWithFormat:@"%@TableCell", self.accountName ]; 
    _logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]; 
    
    return _logoImage; 
}


-(OFFlickrAPIContext*) apiContext
{
    if (!_apiContext)
    {
        if (self.api_key && self.signature)
        {
            _apiContext = [[OFFlickrAPIContext alloc] initWithAPIKey:self.api_key sharedSecret:self.signature authEndPoint:k500PXAuthEndPoint restEndPoint:k500PXRESTEndPoint]; 
            _apiContext.messageType = @"JSON"; 
        }
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
    self.apiContext = [[[OFFlickrAPIContext alloc] initWithAPIKey:self.api_key sharedSecret:self.signature authEndPoint:k500PXAuthEndPoint restEndPoint:k500PXRESTEndPoint] autorelease];
    self.apiContext.messageType = @"JSON"; 

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



-(NSString*) accountName
{
    return @"fiveHundredPXAccount"; 
}


-(BOOL) isActive
{
    BOOL result =  (self.accessToken) && ( [self.accessToken length]); 
    return result; 
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
    NSDictionary* fhp = [ud valueForKey:self.accountName]; 
    
    if (!fhp) 
        return; 
    
    //remember we don't store the requestToken, just the accessTOken
    [self setAccessToken:[fhp objectForKey:@"accessToken"] withSecret:[fhp objectForKey:@"accessSecret"]]; 
    
    //the rest is taken care of by the super
    [super loadSettings]; 
    
}

-(void) saveSettings
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* prevSettings = [ud valueForKey:self.accountName]; 
    
    NSMutableDictionary* fhp = [NSMutableDictionary dictionaryWithDictionary:prevSettings]; 
    
    
    if (self.accessToken)     
        [fhp setValue:self.accessToken forKey:@"accessToken"]; 
    else 
        [fhp removeObjectForKey:@"accessToken"]; 
        
    if (self.accessSecret)
        [fhp setValue:self.accessSecret  forKey:@"accessSecret"]; 
    else
        [fhp removeObjectForKey:@"accessSecret"]; 
    
    [ud setValue:fhp forKey:self.accountName]; 
    
    
    //the rest is taken care of by the super 
    [super saveSettings]; 
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

-(void) dealloc
{
    
    
    [self setAccessToken:nil withSecret:nil]; 
    [self setRequestToken:nil withSecret:nil]; 
    self.apiContext = nil; 
    
    [super dealloc]; 
}

-(void) activateWithAccessToken:(NSString *)at accessSecret:(NSString *)ats
{
    [self setAccessToken:at withSecret:ats]; 
    
    [super activate];       //this should be called last 

    
    
    [[ImageDataProviderManager mainDataProvider].fiveHundredPXProvider getUserInfoForObserver:self]; //will be informed when done
}


-(void) didGetUserDetails:(NSDictionary *)params
{
    NSDictionary* user = [params objectForKey:@"user"]; 
    NSString* un = [user objectForKey:@"username"]; 
    NSString* uid = [user objectForKey:@"id"]; 
    NSString* iurl = [user objectForKey:@"userpic_url"]; 
//    NSString* domain = [user objectForKey:@"domain"]; 
//    iurl = [NSString stringWithFormat:@"http://%@%@", domain, iurl]; 
    //            NSString* fn  = [params objectForKey:@"fullname"]; 
    
    if (!un || !iurl || !uid)       //broadcast the error 
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountDetailFailed" object:self];         
    else {
        self.username = un; 
        self.userid = uid; 
        
        NSData* iconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:iurl] options:NSDataReadingMapped error:nil]; 
        self.userIconImage = [UIImage imageWithData:iconData];
        
        
        [self saveSettings]; //also broadcast the change 
    }
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


@end
