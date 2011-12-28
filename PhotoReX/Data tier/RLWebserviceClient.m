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

@synthesize requestRecommend=_requestRecommend;
@synthesize requestImageViewed=_requestImageViewed; 

@synthesize userid = _userid; 


+(RLWebserviceClient*) standardClient
{
    if (!_rlWebServiceClient)
        _rlWebServiceClient = [[RLWebserviceClient alloc] init]; 
    
    return _rlWebServiceClient; 
}

//this is a copy property
-(void) setUserid:(NSString *)userid
{
    [_userid release]; 
    _userid = [userid copy];
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    [ud setValue:_userid   forKey:@"masterAccountID"];     
}


-(void) loadUserid
{
    //TODO: remove this
    return; 
    
    
    //---------- read user defaults for the master account ID 
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSString* masterID = [ud valueForKey:@"masterAccountID"]; 
    
    if (masterID) 
    {
        _userid = [masterID copy] ;     //don't call the setter method here 
        return; 
    }
}


-(void) registerAsNewAccount
{
    CFUUIDRef uuidRef =  CFUUIDCreate(NULL); 
    NSString* uuid = (NSString*) CFUUIDCreateString(NULL, uuidRef); 
    NSString* body = [NSString stringWithFormat:@"{\"uuid\":\"%@\"}", uuid]; 
    //get a new one from the website 
    [self.requestImageViewed setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
        
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_CREATE_USER]]; 
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url]; 
    [request setHTTPMethod:@"POST"]; 
    [request  addValue:@"application/json" forHTTPHeaderField:@"content-type"]; 
    [request  addValue:@"utf8" forHTTPHeaderField:@"charset"]; 
        
    
    //TODO: remove this 
    self.userid = uuid; 
    return; 
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:
         ^(NSURLResponse* response, NSData* data, NSError* error)
         {
             if (response == nil)       //error happened
             {
             } else         //success
             {
                 NSString* datastr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]; 
                 //NSLog(@"received data for new user  as %@\n", datastr); 
                 
                 
                 SBJsonParser* parser = [[[SBJsonParser alloc] init] autorelease]; 
                 parser.maxDepth = 4; 
                 NSDictionary* d1 = [parser objectWithData:data]; 
                 
                 if (d1 == nil) { NSLog(@"wrong username format: %@\n ", datastr);return;}
                 
                 
                 NSDictionary* d2 = [parser objectWithString:[d1 objectForKey:@"d"]]; 
                 
                 if (d2 == nil) { NSLog(@"wrong username format: %@\n", datastr); return;}
                 
                 
                 NSString* usernameStr = [d2 objectForKey:@"masterAcountID"];     //use the setter to save to default
                 
                 if (usernameStr.length>0)
                     self.userid = usernameStr; 
             }
        }];    
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self loadUserid]; 
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
             
            // NSString* datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
             //NSLog(@"received data as %@\n", datastr); 
             
             
             //use the data and extract the array of pictureID's
             
             SBJsonParser* parser = [[SBJsonParser alloc] init]; 
             
             parser.maxDepth = 4; 
             
             NSDictionary* d1 = [parser objectWithData:data]; 
             
             if (d1 == nil) { NSLog(@"the data from webservice was not formatted correctly"); theBlock(nil, nil); [parser release]; return;}
             
             
             //NSString* datastr = [d1 objectForKey:@"d"]; 
       //      NSLog(@"stripped data %@\n", datastr); 
             
             NSDictionary* d2 = [parser objectWithString:[d1 objectForKey:@"d"]]; 
//             NSDictionary* d2 = [d1 objectForKey:@"d"];         //for some reason, this is always present (all the data is wrapped in a d field)

             
             
             if (d2 == nil) { NSLog(@"the data from webservice was not formatted correctly"); theBlock(nil, nil); [parser release]; return;}
             
             
             NSString* pageid = [d2 objectForKey:@"pageid"]; 
             NSArray*  pages  = [d2 objectForKey:@"pages"]; 
             
             if (pageid==nil || pages == nil) { NSLog(@"the data from webservice was not formatted correctly"); theBlock(nil, nil); [parser release]; return;}
             
             
             //we finally have all the stuff we need. lets call the block: 
             theBlock(pageid, pages); 

             //cleanup 
             [parser release];
             
         }// if 
         
     }]; 
     
}


-(void) sendPageActivityAsync:(NSString *)pageid pictureIndex:(int)index
{    
    if (!self.userid) 
        return; 

    NSString* body = [NSString stringWithFormat:@"{\"userid\":\"%@\",\"collectionID\":\"%@\",\"picIndex\":\"%d\"}", self.userid, pageid, index]; 
    
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
    if (!self.userid)
        return; 
    
    //create the json string out of the dictionary 
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter new] autorelease];
    NSDictionary* message = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userid, @"userid", account, @"account", nil]; 
    NSString *body = [jsonWriter stringWithObject:message];
    
    
    [self.requestImageViewed setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_REGISTER_ACCOUNT]]; 
    
    //create a request (dont have an ivar for this) 
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url]; 
    
    //set parameters of the request except for the body: 
    [request setHTTPMethod:@"POST"]; 
    
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
}


-(void) deregsiterAccountAsync:(NSDictionary *)account
{
    if (!self.userid)
        return; 
    
        //create the json string out of the dictionary 
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSDictionary* message = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.userid, @"userid", account, @"account", nil]; 
        NSString *body = [jsonWriter stringWithObject:message];
        
        
        [self.requestImageViewed setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_DEREGISTER_ACCOUNT]]; 
        
        //create a request (dont have an ivar for this) 
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url]; 
        
        //set parameters of the request except for the body: 
        [request setHTTPMethod:@"POST"]; 
        
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
}


-(void) dealloc
{
    self.userid = nil; 
    [_requestRecommend release]; 
    [_requestImageViewed release]; 
    [super dealloc]; 
}

@end
