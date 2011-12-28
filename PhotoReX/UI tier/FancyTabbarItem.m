//
//  FancyTabbarItem.m
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "FancyTabbarItem.h"

@implementation FancyTabbarItem
@synthesize selected=_selected; 
@synthesize textLabel=_textLabel; 
@synthesize parentIndex=_parentIndex; 


-(void) setSelected:(BOOL)selected
{
    if (selected) 
        self.textLabel.textColor = [UIColor whiteColor]; 
    else
        self.textLabel.textColor = [UIColor grayColor]; 
}


-(UILabel*) textLabel
{
    if(!_textLabel)
    {
        _textLabel = [[UILabel alloc] init]; 
        
        _textLabel.textAlignment = UITextAlignmentCenter; 
        _textLabel.textColor = [UIColor grayColor]; 
        _textLabel.backgroundColor = [UIColor clearColor]; 
        _textLabel.font = [UIFont fontWithName:@"futura" size:10]; 
        
        [self addSubview:_textLabel]; 
        [_textLabel release]; 
    }
    return _textLabel; 
}

-(id) init
{
    self = [super init]; 
    
    if (self) 
    {
        _selected = NO; 
        self.clipsToBounds = NO; 
    }
    
    return self; 
}

+(FancyTabbarItem*) buttonWithName:(NSString *)name andImageName:(NSString *)img
{
    FancyTabbarItem* result = [[FancyTabbarItem alloc] init]; 
    
    [result setImage:[UIImage imageNamed:img] forState:UIControlStateNormal]; 
    result.textLabel.text = name; 
    
    return [result autorelease]; 
}

+(CGFloat) buttonHeight
{
    return  42; 
}


-(void) layoutSubviews
{
    [super layoutSubviews]; 

    
    CGFloat IMAGE_SIZE = 32;    //the size of the image in the button (its square) 
    
    
    CGRect b = self.bounds; 
    
    CGFloat inset = (b.size.width - IMAGE_SIZE)/2.0;    //put the image in the middle 
    CGRect f = CGRectMake(b.origin.x + inset, b.origin.y, IMAGE_SIZE, IMAGE_SIZE); 
    
    self.imageView.frame = f; 
    
    CGFloat y = b.origin.y + f.size.height;  
    f = CGRectMake(b.origin.x, y-4, b.size.width, b.size.height-y); 
    self.textLabel.frame = f; 
}


-(void) dealloc
{
    self.textLabel = nil; 
    
    [super dealloc]; 
}




@end
