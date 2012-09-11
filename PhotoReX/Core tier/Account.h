//
//  Account.h
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PictureInfoDetails; 
@class ImageDataProviderManager; 

//This is an abstract class to represent user account in a website
// isActive means there's a username associated with this account 
// isEnabled means we should retrieve pics from this account. they can be true/false independently
@interface Account: NSObject 
{
    UIImage* _logoImage;            //static logo of the account
    UIImage* _iconImage;            //static icon of the account (32X32) 
    UIImage* _userIconImage;        //dynamic icon of the username
    NSString* _username; 
    NSString* _userid; 
    
    BOOL _enabled;                //true means we can show pictures from this account (different from isActive). 
    
}

-(BOOL) isActive;         //returns true if the account has been set up and ready to use (there's a username assoc with it)


-(NSString*) accountName; 
-(void) didReceiveMemoryWarning; 

//load and save settings related to this account in to the plist 
-(void) loadSettings; 
-(void) saveSettings; 

-(void) activate;       
-(void) deactivate; 

-(void) broadcastChange;                //uses NSNotification to inform everyone that this account has been changed
-(NSDictionary*) dictionaryRepresentation;      //this is for sending account info to our website 


-(BOOL) supportsFavorite;           //whether this account supports making the photo favorite

@property (readonly, nonatomic) UIImage* logoImage; 
@property (readonly, nonatomic) UIImage* iconImage; 
@property (nonatomic, retain) UIImage* userIconImage; 
@property (nonatomic, copy) NSString* username; 
@property (nonatomic, copy) NSString* userid; 

@property (nonatomic) BOOL enabled; 
@end




@interface InstagramAccount : Account {
}





@end