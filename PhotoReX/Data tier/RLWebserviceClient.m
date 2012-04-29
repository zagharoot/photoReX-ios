//
//  RLWebserviceClient.m
//  rlimage
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "RLWebserviceClient.h"
#import "NetworkActivityIndicatorController.h"
#import "SBJsonWriter.h"


static RLWebserviceClient* _rlWebServiceClient= nil; 


@implementation RLWebserviceClient


static NSString* SERVER_ADDRESS =   @"";

static NSString* SERVICE_RECOMMEND          = @"recommend" ;
static NSString* SERVICE_IMAGEVIEWED        = @"updateModel";
static NSString* SERVICE_REGISTER_ACCOUNT   = @"registerAccount";
static NSString* SERVICE_DEREGISTER_ACCOUNT = @"deregisterAccount";
static NSString* SERVICE_CREATE_USER        = @"createUser";


@synthesize requestRecommend=_requestRecommend;
@synthesize requestImageViewed=_requestImageViewed; 

@synthesize userid = _userid; 
@synthesize signature=_signature; 
@synthesize webServiceLocation=_webServiceLocation; 


-(void) setWebServiceLocation:(enum WebServiceLocation)location
{
    _webServiceLocation = location; 
    switch (location) {
        case RLWEBSERVICE_LAPTOP:
                SERVER_ADDRESS = @"http://68.45.157.225/rlimage/imagerecommendationservice.asmx/";
            break;
        case RLWEBSERVICE_MAC:
                SERVER_ADDRESS = @"http://192.168.10.102:3000/ws/"; 
            break;
        case RLWEBSERVICE_AMAZON: 
                SERVER_ADDRESS = @"http://23.21.119.56:3000/ws/"; 
            break;
    }
    
    
    //update the url of the request objects: 
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_RECOMMEND]]; 
    _requestRecommend.URL = url; 
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_IMAGEVIEWED]]; 
    _requestImageViewed.URL = url; 
    

}


+(RLWebserviceClient*) standardClient
{
    if (!_rlWebServiceClient)
    {
        _rlWebServiceClient = [[RLWebserviceClient alloc] init]; 
    }
    
    return _rlWebServiceClient; 
}

//this is a copy property
-(void) setUserid:(NSString *)userid
{
    [_userid release]; 
    _userid = [userid copy];    
}

//this is a copy property
-(void) setSignature:(NSString *)signature
{
    [_signature release]; 
    _signature = [signature copy]; 
    
}


-(void) saveSettings 
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
    NSDictionary* webservice = [ud valueForKey:@"webservice"]; 
    NSMutableDictionary* mwebservice; 
    if (webservice)
        mwebservice = [NSMutableDictionary dictionaryWithDictionary:webservice]; 
    else
        mwebservice = [NSMutableDictionary dictionaryWithCapacity:3]; 
    
    [mwebservice setValue:self.userid forKey:@"masterAccountID"]; 
    [mwebservice setValue:[NSNumber numberWithInt:self.webServiceLocation] forKey:@"location"]; 
    [mwebservice setValue:self.signature forKey:@"masterAccountSignature"]; 
    
    [ud setValue:mwebservice forKey:@"webservice"]; 
}


-(void) loadSettings
{
    
    
    //---------- read user defaults for the master account ID 
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
    NSDictionary* webservice = [ud valueForKey:@"webservice"]; 
    self.webServiceLocation = RLWEBSERVICE_MAC; 
    
    if (webservice)
    {
        NSString* masterID = [webservice valueForKey:@"masterAccountID"]; 
        NSString* sig = [webservice valueForKey:@"masterAccountSignature"] ;
        NSNumber* location = [webservice valueForKey:@"location"]; 
        
        if (masterID) 
            _userid = [masterID copy] ;     //don't call the setter method here 
        
        if (sig)
            _signature = [sig copy];        //don't call the setter method here 
        
        if (location)
            self.webServiceLocation = location.intValue; 
        else
            self.webServiceLocation = RLWEBSERVICE_MAC; 
    }
}


-(void) registerAsNewAccount
{
    CFUUIDRef uuidRef =  CFUUIDCreate(NULL); 
    NSString* uuid = (NSString*) CFUUIDCreateString(NULL, uuidRef); 
    NSString* body = [NSString stringWithFormat:@"{\"secret\":\"%@\"}", uuid]; 
        
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_CREATE_USER]]; 
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url]; 
    [request setHTTPMethod:@"POST"]; 
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
    [request  addValue:@"application/json" forHTTPHeaderField:@"content-type"]; 
    [request  addValue:@"utf8" forHTTPHeaderField:@"charset"]; 
        
    
    //TODO: remove this 
//    self.userid = uuid; 
//    return; 
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
         ^(NSURLResponse* response, NSData* data, NSError* error)
         {
             if (response == nil)       //error happened
             {
             } else         //success
             {
                 NSString* datastr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
                 NSLog(@"received data for new user  as %@\n", datastr); 
                 
                 
                 SBJsonParser* parser = [[[SBJsonParser alloc] init] autorelease]; 
                 parser.maxDepth = 4; 
                 NSDictionary* d1 = [parser objectWithData:data]; 
                 
                 if (d1 == nil) { NSLog(@"wrong username format: %@\n ", datastr);return;}
                 
                 
//                 NSDictionary* d2 = [parser objectWithString:[d1 objectForKey:@"d"]]; 
                 NSDictionary* d2 = [d1 objectForKey:@"d"]; 
                 
                 if (d2 == nil) { NSLog(@"wrong username format: %@\n", datastr); return;}
                 
                 
                 NSString* usernameStr = [[d2 objectForKey:@"masterAcountID"] description];     //use the setter to save to default
                 
                 if (usernameStr.length>0)
                 {
                     self.userid = usernameStr; 
                     self.signature = uuid; 
                 }
             }
        }];    
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self loadSettings]; 
        if (! self.userid)
            [self registerAsNewAccount]; 
        
        //create the request: only the body part of the request remains to be created on the fly at each call
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_RECOMMEND]]; 
        _requestRecommend = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60]; 
 
            
        //set parameters of the request except for the body: 
        [self.requestRecommend setHTTPMethod:@"POST"]; 
        
        [self.requestRecommend addValue:@"application/json" forHTTPHeaderField:@"content-type"]; 
        [self.requestRecommend addValue:@"utf8" forHTTPHeaderField:@"charset"]; 
        
        //--------------------
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_IMAGEVIEWED]]; 
        _requestImageViewed = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60]; 
        
        //set parameters of the request except for the body: 
        [self.requestImageViewed setHTTPMethod:@"POST"]; 
        
        [self.requestImageViewed addValue:@"application/json" forHTTPHeaderField:@"content-type"]; 
        [self.requestImageViewed addValue:@"utf8" forHTTPHeaderField:@"charset"]; 
        
        
//        [self.request setHTTPBody: [ body dataUsingEncoding:NSUTF8StringEncoding]]; 
    }
    
    return self;
}


// retrieves some pages of pictureInfos from the rl webservice in the background. Once completed, the handle block is executed. 
// if an error occurs, the block is called with nil arguments 
-(void) getPageFromServerAsync:(int)howMany andRunBlock:(void (^)(NSString *, NSArray *))theBlock
{
    if (!self.userid) 
        return; 
    
    
    NSString* body = [NSString stringWithFormat:@"{\"userid\":\"%@\",\"howMany\":\"%d\"}", self.userid, howMany]; 
    
    [self.requestRecommend setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    
    //increment network activity
    [NetworkActivityIndicatorController incrementNetworkConnections]; 
    
    
    [NSURLConnection sendAsynchronousRequest:self.requestRecommend queue:[NSOperationQueue mainQueue] completionHandler:
    ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         //decrement network activity
         [NetworkActivityIndicatorController decrementNetworkConnections]; 
        
//         NSLog(@"i'm here -------------\n"); 
         if (response == nil)       //error happened
         {
             NSLog(@"Error downloading data from RLService: %@\n", [error description]); 
             theBlock(@"", nil); 
         } else         //success
         {
             
             NSString* datastr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
           //  NSLog(@"received data as %@\n", datastr); 
             
             
             SBJsonParser* parser = [[SBJsonParser alloc] init]; 
             parser.maxDepth = 6; 
             

             NSDictionary* d1 = [parser objectWithData:data]; 
             if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly"); theBlock(nil, nil); [parser release]; return;}
                          

             
             NSDictionary* d2; 
             if (self.webServiceLocation == RLWEBSERVICE_LAPTOP)
             {
                 //getting from ASP.NET ---------
                 d2 = [parser objectWithString:[d1 objectForKey:@"d"]]; 
                 if (d2 == nil) { NSLog(@"the data from webservice was not formatted correctly"); theBlock(nil, nil); [parser release]; return;
                 }
             }else
                 d2 = d1; 
             
             
             NSString* pageid = [d2 objectForKey:@"pageid"]; 
             NSArray*  pages  = [d2 objectForKey:@"pics"]; 
             
             if (pageid==nil || pages == nil) { NSLog(@"the data from webservice was not formatted correctly"); theBlock(nil, nil); [parser release]; return;}
             
             
             //we finally have all the stuff we need. lets call the block: 
             theBlock(pageid, pages); 

             //cleanup 
             [parser release];
             
         }// if 
         
     }]; 
     
}


-(void) sendPageActivityAsync:(NSString *)pageid pictureHash:(NSString*) hash
{    
    if (!self.userid) 
        return; 

    NSString* body = [NSString stringWithFormat:@"{\"userid\":\"%@\",\"collectionID\":\"%@\",\"picHash\":\"%@\"}", self.userid, pageid, hash]; 
    
    [self.requestImageViewed setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    //NSLog(@"sending user activity for collection %@ pic index %d to server\n", pageid,index );
    
    [NSURLConnection sendAsynchronousRequest:self.requestImageViewed queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (response == nil)       //error happened
         {
             //TODO: we need to save to disk to try again later 
         } else         //success
         {
            //TODO: do we need to actually do an ack here? 
         }
     }]; 
}


-(void) registerAccountAsync:(NSDictionary *)account
{
    //TODO: call createnewuser and have this be called back upon success
    if (!self.userid)
        return; 
    
    //create the json string out of the dictionary 
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter new] autorelease];
    NSDictionary* message = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userid, @"userid", account, @"account", nil]; 
    NSString *body = [jsonWriter stringWithObject:message];
    
    

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_REGISTER_ACCOUNT]]; 
    
    //create a request (dont have an ivar for this) 
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url]; 
    
    //set parameters of the request except for the body: 
    [request setHTTPMethod:@"POST"]; 
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    [request  addValue:@"application/json" forHTTPHeaderField:@"content-type"]; 
    [request  addValue:@"utf8" forHTTPHeaderField:@"charset"]; 
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (response == nil)       //error happened
         {
             //TODO: we need to save to disk to try again later 
         } else         //success
         {
             //TODO: we might have been linked to another account. update the userid/signature if necessary 
         }
     }]; 
}


-(void) deregsiterAccountAsync:(NSDictionary *)account
{
    if (!self.userid)
        return; 
    
        //create the json string out of the dictionary 
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSDictionary* message = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userid, @"userid", account, @"account", nil]; 
        NSString *body = [jsonWriter stringWithObject:message];
        
        
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_DEREGISTER_ACCOUNT]]; 
        
        //create a request (dont have an ivar for this) 
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url]; 
        
        //set parameters of the request except for the body: 
        [request setHTTPMethod:@"POST"]; 
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
        
        [request  addValue:@"application/json" forHTTPHeaderField:@"content-type"]; 
        [request  addValue:@"utf8" forHTTPHeaderField:@"charset"]; 
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
         ^(NSURLResponse* response, NSData* data, NSError* error)
         {
             if (response == nil)       //error happened
             {
                 //TODO: we need to save to disk to try again later 
             } else         //success
             {
                 //TODO: do we need to actually do an ack here? 
             }
         }]; 
    
    [jsonWriter release]; 
}


-(void) dealloc
{
    [self saveSettings]; 
    self.userid = nil; 
    [_requestRecommend release]; 
    [_requestImageViewed release]; 
    [super dealloc]; 
}

@end
