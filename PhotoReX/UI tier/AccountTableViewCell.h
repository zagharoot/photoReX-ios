//
//  AccountTableViewCell.h
//  rlimage
//
//  Created by Ali Nouri on 7/4/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@protocol AccountActiveStatusDelegate <NSObject>

-(void) accountStatusDidChange; 

@end

@interface AccountTableViewCell : UITableViewCell <AccountActiveStatusDelegate>
{
    NSString* imgPath; 
    UIImageView* _img; 
    UIImageView* _isActiveImage; 
    Account* _account; 
}


@property (nonatomic, retain) UIImageView* logoImageView; 
@property (nonatomic, retain) UIImageView* isActiveImageView; 
@property (nonatomic, retain) Account* theAccount; 




- (id) initWithFrame:(CGRect)frame andAccount:(Account*) a; 

-(void) updateActiveImage; 


@end
