//
//  RLWebserviceClient.m
//  rlimage
//
//  Created by Ali Nouri on 7/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "RLWebserviceClient.h"
#import "NetworkActivityIndicatorController.h"

@implementation RLWebserviceClient

@synthesize request=_request; 
@synthesize userid = _userid; 

- (id)initWithUserid:(NSString*) u
{
    self = [super init];
    if (self) {
        self.userid = u; 
        
        
        //create the request: only the body part of the request remains to be created on the fly at each call
        NSURL* url = [NSURL URLWithString:SERVER_ADDRESS]; 
        _request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:60]; 
        
        //set parameters of the request except for the body: 
        [self.request setHTTPMethod:@"POST"]; 
        
        [self.request addValue:@"application/json" forHTTPHeaderField:@"content-type"]; 
        [self.request addValue:@"utf8" forHTTPHeaderField:@"charset"]; 
        
//        [self.request setHTTPBody: [ body dataUsingEncoding:NSUTF8StringEncoding]]; 
    }
    
    return self;
}


// retrieves some pages of pictureInfos from the rl webservice in the background. Once completed, the handle block is executed. 
// if an error occurs, the block is called with nil arguments 
-(void) getPageFromServerAsync:(int)howMany andRunBlock:(void (^)(NSString *, NSArray *))theBlock
{
    NSString* body = [NSString stringWithFormat:@"{\"userid\":\"%@\",\"howMany\":\"%d\"}", self.userid, howMany]; 
    
    [self.request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    
    //increment network activity
    [NetworkActivityIndicatorController incrementNetworkConnections]; 
    
    
    [NSURLConnection sendAsynchronousRequest:self.request queue:[NSOperationQueue mainQueue] completionHandler:
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


-(void) sendPageActivity:(NSString *)pageid pictureIndex:(int)index
{
    //TODO: send the data to the server. Also, save locally and redo later if connection failed
    //remember to take care of network activity
}



-(void) dealloc
{
    self.userid = nil; 
    [_request release]; 
}

@end
