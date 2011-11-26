//
//  Account.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>

//This is an abstract class to represent user account in a website
@interface Account: NSObject 
{
    UIImage* _logoImage; 
}

-(BOOL) isActive;         //returns true if the account has been set up and ready to use

-(NSString*) accountName; 
-(void) didReceiveMemoryWarning; 

@property (readonly, nonatomic) UIImage* logoImage; 
@end




@interface InstagramAccount : Account {
}





@end