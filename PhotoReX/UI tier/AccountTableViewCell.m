//
//  AccountTableViewCell.m
//  rlimage
//
//  Created by Ali Nouri on 7/4/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "AccountTableViewCell.h"
#import "AccountsUIViewController.h" 


@implementation AccountTableViewCell
@synthesize logoImageView=_img; 
@synthesize isActiveImageView=_isActiveImage; 
@synthesize theAccount = _account; 
@synthesize rightIndicator=_rightIndicator; 
@synthesize status = _status; 

@synthesize userIconImage=_userIconImage; 
@synthesize deactivateSwitch=_deactivateSwitch; 
@synthesize usernameLabel=_usernameLabel; 

//this is a retain property
-(void) setTheAccount:(Account *)theAccount
{
    //inform notification center that we don't need update for previous account 
    if (_account)
        [[NSNotificationCenter defaultCenter] removeObserver:self]; 
    
    [_account release]; 
    _account = [theAccount retain]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountDetailsDidChange:) name:@"AccountDetailsDidChange" object:_account]; 
}


-(void) setStatus:(enum ACCOUNTCELL_STATUS)status animated:(BOOL)animated
{
//    if (_status == status) 
//        return; 

    _status = status; 
    
    CGAffineTransform swingTransform = CGAffineTransformIdentity;
    swingTransform = CGAffineTransformRotate(swingTransform, M_PI_2*status);
    
    
    if (animated)
    {
        [UIView beginAnimations:@"swing" context:self.rightIndicator];
        [UIView setAnimationDuration:0.25];
    }
    
    self.rightIndicator.transform = swingTransform;
    
    if (animated) 
        [UIView commitAnimations];
}

-(void) setStatus:(enum ACCOUNTCELL_STATUS)status
{
    [self setStatus:status animated:NO]; 
}

-(UISwitch*) deactivateSwitch
{
    if (!_deactivateSwitch)
    {
        _deactivateSwitch = [[UISwitch alloc] init]; 
        [_deactivateSwitch setOn:YES]; 
        [_deactivateSwitch addTarget:self action:@selector(deactivateAccount:) forControlEvents:UIControlEventValueChanged]; 
        
        [self addSubview:_deactivateSwitch]; 
    }
    
    [_deactivateSwitch setOn:YES]; 
    
    return _deactivateSwitch; 
}

-(UILabel*) usernameLabel
{
    if (!_usernameLabel)
    {
        _usernameLabel = [[UILabel alloc] init]; 
        
        _usernameLabel.textColor = [UIColor grayColor];
        _usernameLabel.backgroundColor = [UIColor clearColor]; 
        _usernameLabel.font = [UIFont fontWithName:@"futura" size:17]; 
        [self addSubview:_usernameLabel]; 
    }
    
    return _usernameLabel; 
}


-(UIImageView*) userIconImage
{
    if (!_userIconImage) 
    {
        UIImage* iconImage = self.theAccount.userIconImage; 
        
        if (!iconImage) 
            iconImage = [UIImage imageNamed:@"defaultIconImage.png"]; 
        
        _userIconImage = [[UIImageView alloc] initWithImage:iconImage];
        [self addSubview:_userIconImage]; 
    }
    
    return _userIconImage; 
}

//create the image view lazily
-(UIImageView*) logoImageView
{
    if (_img == nil) 
        _img = [[UIImageView alloc] init]; 
    
    return _img; 
}


-(UIImageView*) isActiveImageView
{
    if (_isActiveImage==nil)
        _isActiveImage = [[UIImageView alloc] init]; 
    
    return _isActiveImage; 
}


-(UIImageView*) rightIndicator
{
    if (_rightIndicator==nil)
        _rightIndicator = [[UIImageView alloc] init]; 
    
    return _rightIndicator; 
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //disable this method all together? 
    return nil; 
    
/*    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
*/

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
 
    if (! selected) 
        return; 
    
    if (!self.theAccount.isActive)
        return; 
    
    if (self.status == ACCOUNTCELL_ACTIVE_COMPACT) 
    {
        [self setStatus:ACCOUNTCELL_ACTIVE_EXPANDED animated:YES]; 
        CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 130); 
        self.frame = frame; 
        
        //show extended elements 
        self.deactivateSwitch.hidden = NO; 
        self.userIconImage.hidden = NO; 
        
    }
    else
    {
        [self setStatus:ACCOUNTCELL_ACTIVE_COMPACT animated:YES]; 
        CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 60); 
        self.frame = frame; 
        
        
        //hide extended elements 
        self.deactivateSwitch.hidden = YES; 
        self.userIconImage.hidden = YES; 
        
        
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay]; 
    
}

- (id) initWithFrame:(CGRect)frame andAccount:(Account*) a andTableController:(AccountsUIViewController *)p
{
//    if (self = [super initWithFrame:frame]) 
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"])
    {
        self.theAccount = a; 
        parent = p; 
        
        self.logoImageView.image = a.logoImage; 
        UIImage* img = [UIImage imageNamed:@"tableCellIndicator.png"]; 
        self.rightIndicator.image = img; 

        [self updateActiveImage]; 

        self.usernameLabel.text = @"[]"; 
        
        [self.contentView addSubview:self.logoImageView]; 
        [self.contentView addSubview:self.isActiveImageView]; 
        [self.contentView addSubview:self.rightIndicator]; 

        self.status = self.theAccount.isActive? ACCOUNTCELL_ACTIVE_COMPACT: ACCOUNTCELL_INACTIVE; 
        
        self.clipsToBounds = YES; 
        self.selectionStyle = UITableViewCellSelectionStyleNone; 
    
    }
    
    return self; 
}


-(void) deactivateAccount:(id)sender
{
    NSLog(@"deactivating the account\n"); 

    [self setStatus:ACCOUNTCELL_INACTIVE animated:YES]; 
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 60); 
    self.frame = frame; 
    
    //hide extended elements 
    self.deactivateSwitch.hidden = YES; 
    self.userIconImage.hidden = YES; 
    
    //deactivate the account 
    [self.theAccount deactivate]; 
    
    //redraw table 
    [parent reevaluateHeights]; 

    [self updateActiveImage]; 
}

-(void) accountDetailsDidChange:(NSNotification*) notification
{
    self.status = self.theAccount.isActive? ACCOUNTCELL_ACTIVE_COMPACT: ACCOUNTCELL_INACTIVE; 
    [self updateActiveImage]; 
    
    //update stuff inside the cell 
    if (self.theAccount.isActive)
    {
        if (self.theAccount.username)
            self.usernameLabel.text = self.theAccount.username; 
    }
    
    
    self.selected = NO; 
}

-(void) updateActiveImage
{
    //create the activeIcon depending on whther the account is active or not
    if ([self.theAccount isActive])
    {
        imgPath = [[NSBundle mainBundle] pathForResource:@"accountActive" ofType:@"png"]; 
    }else
    {
        imgPath = [[NSBundle mainBundle] pathForResource:@"accountInactive" ofType:@"png"]; 
    }
    
    
    UIImage* img = [[[UIImage alloc] initWithContentsOfFile:imgPath] autorelease]; 
    self.isActiveImageView.image = img; 
    
    [self setNeedsDisplay]; 
}

//define how the contents are displayed in the bounding box
-(void) layoutSubviews
{
    [super layoutSubviews]; 
    
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame= CGRectMake( boundsX+20 ,17, 25, 25);
    self.isActiveImageView.frame = frame;
    
    frame= CGRectMake( boundsX+50 ,0, 250, 55);
    self.logoImageView.frame = frame;
    
    
    frame = CGRectMake( boundsX + contentRect.size.width - 10 - 20, 17, 20 , 20) ; 
    self.rightIndicator.frame = frame; 
    
    
    if (self.status == ACCOUNTCELL_ACTIVE_EXPANDED)
    {
        CGFloat topExtend = 50; 
        frame = CGRectMake(boundsX + contentRect.size.width - 10 - 70, contentRect.size.height-topExtend, 30 , 20) ; 
        self.deactivateSwitch.frame = frame; 
        

        frame= CGRectMake( boundsX+20 ,70, 50, 50);
        self.userIconImage.frame = frame; 
        
        
        frame = CGRectMake(boundsX+ 80, 70, 120, 30); 
        self.usernameLabel.frame = frame; 
        
    }
}


-(void) dealloc
{
    self.logoImageView = nil; 
    self.isActiveImageView = nil; 
    self.theAccount = nil; 
    self.rightIndicator = nil; 
    
    self.userIconImage = nil; 
    self.deactivateSwitch = nil; 
    self.usernameLabel = nil; 
    
    [super dealloc]; 
}


@end
