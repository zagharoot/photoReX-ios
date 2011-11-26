//
//  NetworkActivityIndicatorController.h
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>

//  This class provides a tool to activate/deactivate the network indicator in the status bar 
//  This class implements a singleton and there are two methods to call: 
//  Each time a network connection is made, we call incrementNetworkConnections and each time 
//  the connection is ended (finished/error) we call decrementNetworkConnections

@interface NetworkActivityIndicatorController : NSObject
{
    int _numberOfConnections; //how many active connections there is
}

+(void) incrementNetworkConnections; 
+(void) decrementNetworkConnections; 

@property (atomic) int numberOfConnections; 

@end
