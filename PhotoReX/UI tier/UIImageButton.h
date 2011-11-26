//
//  UIImageButton.h
//  rlimage
//
//  Created by Ali Nouri on 10/17/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINetImageView.h"

@interface UIImageButton : UIControl
{
    UINetImageView* _imageView; 
    UIBezierPath * shadowPath;
    BOOL isPushedDown;                  //indicates whether the current state of the button is pushed down 
}


-(id) initWithImage:(UINetImageView*) img; 

//two methods that are called when user pushes the button and releases it 
-(void) pushdown; 
-(void) popup; 

@property (nonatomic, retain) UINetImageView* imageView; 
@end
