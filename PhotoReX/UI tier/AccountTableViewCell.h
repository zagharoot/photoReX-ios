//
//  AccountTableViewCell.h
//  rlimage
//
//  Created by Ali Nouri on 7/4/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

enum ACCOUNTCELL_STATUS
{
    ACCOUNTCELL_INACTIVE = 0, 
    ACCOUNTCELL_ACTIVE_COMPACT = + 1, 
    ACCOUNTCELL_ACTIVE_EXPANDED = -1
};


@class AccountsUIViewController; 

@interface AccountTableViewCell : UITableViewCell 
{
    NSString* imgPath; 
    UIImageView* _img;                  //account image logo 
    UIImageView* _isActiveImage;        //is account active image on the left
    Account* _account; 
    AccountsUIViewController* parent; 
    
    UIImageView* _rightIndicator;       //little indicator image at the right 
    
    //stuff for view when it's extended 
    UIImageView* _userIconImage;        //icon for user picture on the website 
    UISwitch*    _deactivateSwitch; 
    UILabel*     _usernameLabel; 
    
    enum ACCOUNTCELL_STATUS _status; 
}


@property (nonatomic, retain) UIImageView* logoImageView; 
@property (nonatomic, retain) UIImageView* isActiveImageView; 
@property (nonatomic, retain) Account* theAccount; 
@property (nonatomic, retain) UIImageView* rightIndicator; 
@property (nonatomic) enum ACCOUNTCELL_STATUS status; 

@property (nonatomic, retain) UIImageView* userIconImage; 
@property (nonatomic, retain) UISwitch* deactivateSwitch; 
@property (nonatomic, retain) UILabel* usernameLabel; 

- (id) initWithFrame:(CGRect)frame andAccount:(Account*) a andTableController:(AccountsUIViewController*) p; 

-(void) accountDetailsDidChange:(NSNotification*) notification; 

-(void) updateActiveImage; 
-(void) setStatus:(enum ACCOUNTCELL_STATUS)status animated:(BOOL) animated; 
-(void) deactivateAccount:(id) sender; 
@end
