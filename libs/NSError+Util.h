//
//  NSError+Util.h
//  photoReX
//
//  Created by Ali Nouri on 6/20/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
        As a protocol, here are the domains we agree on error reporting: 
        - rlwebsite: any error related to data from rlwebsite
 
 */


@interface NSError (Util)

+(NSError*) errorWithDomain:(NSString*) dom andMessage:(NSString*) msg; 

@end
