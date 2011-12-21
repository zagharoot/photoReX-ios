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
    UIImage* _logoImage;            //static logo of the account
    UIImage* _userIconImage;        //dynamic icon of the username
    NSString* _username; 
    
}

-(BOOL) isActive;         //returns true if the account has been set up and ready to use

-(NSString*) accountName; 
-(void) didReceiveMemoryWarning; 

//load and save settings related to this account in to the plist 
-(void) loadSettings; 
-(void) saveSettings; 

-(void) activate;       
-(void) deactivate; 

-(void) broadcastChange;                //uses NSNotification to inform everyone that this account has been changed
-(NSDictionary*) dictionaryRepresentation;      //this is for sending account info to our website 

@property (readonly, nonatomic) UIImage* logoImage; 
@property (nonatomic, retain) UIImage* userIconImage; 
@property (nonatomic, copy) NSString* username; 
@end




@interface InstagramAccount : Account {
}





@end