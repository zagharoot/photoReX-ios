//
//  AccountTableViewCell.m
//  rlimage
//
//  Created by Ali Nouri on 7/4/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell
@synthesize logoImageView=_img; 
@synthesize isActiveImageView=_isActiveImage; 
@synthesize theAccount = _account; 

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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithFrame:(CGRect)frame andAccount:(Account*) a
{
//    if (self = [super initWithFrame:frame]) 
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"])
    {
        self.theAccount = a; 
        self.logoImageView.image = a.logoImage; 
        
        
        [self updateActiveImage]; 
        
        [self.contentView addSubview:self.logoImageView]; 
        [self.contentView addSubview:self.isActiveImageView]; 
    }
    
    return self; 
}

-(void) accountStatusDidChange
{
    [self updateActiveImage]; 
    self.selected = NO; 
    
}

-(void) updateActiveImage
{
    //create the activeIcon depending on whther the account is active or not
    if ([self.theAccount isActive])
        imgPath = [[NSBundle mainBundle] pathForResource:@"accountActive" ofType:@"png"]; 
    else
        imgPath = [[NSBundle mainBundle] pathForResource:@"accountInactive" ofType:@"png"]; 
    
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
    frame= CGRectMake( boundsX+10 ,17, 25, 25);
    self.isActiveImageView.frame = frame;
    
    frame= CGRectMake( boundsX+50 ,0, 250, 55);
    self.logoImageView.frame = frame;
    
}




-(void) dealloc
{
    self.logoImageView = nil; 
    self.isActiveImageView = nil; 
    self.theAccount = nil; 
}


@end
