//
//  NetworkActivityIndicatorController.m
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "NetworkActivityIndicatorController.h"

static NetworkActivityIndicatorController* theInstance; 

@interface NetworkActivityIndicatorController(Private) {
@private
    
}

+(NetworkActivityIndicatorController*) getInstance; 
@end


@implementation NetworkActivityIndicatorController

@synthesize numberOfConnections=_numberOfConnections; 

-(id) init
{
    self = [super init]; 
    if (self)
    {
        self.numberOfConnections = 0; 
    }
    
    return self; 
}


+(void) incrementNetworkConnections
{
    [NetworkActivityIndicatorController getInstance].numberOfConnections ++; 
    
    //show the indicator 
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


+(void) decrementNetworkConnections
{
    NetworkActivityIndicatorController* instance = [NetworkActivityIndicatorController getInstance]; 
    
    instance.numberOfConnections--; 
    if (instance.numberOfConnections <= 0 )
    {
        //remove the indicator 
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];        
    }
    
}

@end



@implementation NetworkActivityIndicatorController (Private)

+(NetworkActivityIndicatorController*) getInstance
{
    if(!theInstance)
        theInstance = [[NetworkActivityIndicatorController alloc] init]; 
    
    return theInstance; 
}

@end