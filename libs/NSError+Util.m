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


-(void) show
{
    NSString* title = [NSString stringWithFormat:@"Error domain: %@", self.domain]; 
    NSString* desc; 
/*    
    if ([self.userInfo objectForKey:@"message"])
        desc = [NSString stringWithFormat:@"Message: %@", [self.userInfo objectForKey:@"message"]]; 
    else
*/
    desc = [NSString stringWithFormat:@"Detail: %@", self.userInfo.description]; 
    
    
    [YRDropdownView showDropdownInView:[[UIApplication sharedApplication] keyWindow]
                                 title:title 
                                detail:desc 
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES
                             hideAfter:0];
    
}

@end
