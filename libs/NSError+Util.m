//
//  NSError+Util.m
//  photoReX
//
//  Created by Ali Nouri on 6/20/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "NSError+Util.h"

@implementation NSError (Util)


+(NSError*) errorWithDomain:(NSString *)dom andMessage:(NSString *)msg
{
    
    NSDictionary* dic = [NSDictionary dictionaryWithObject:msg forKey:@"message"]; 
    NSError* result = [NSError errorWithDomain:dom code:0 userInfo:dic]; 
    return result; 
}



@end
