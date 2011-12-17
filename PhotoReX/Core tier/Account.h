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
    UIImage* _userIconImage; 
}

-(BOOL) isActive;         //returns true if the account has been set up and ready to use

-(NSString*) accountName; 
-(void) didReceiveMemoryWarning; 

//load and save settings related to this account in to the plist 
-(void) loadSettings; 
-(void) saveSettings; 

@property (readonly, nonatomic) UIImage* logoImage; 
@property (readonly, nonatomic) UIImage* userIconImage; 
@end




@interface InstagramAccount : Account {
}





@end