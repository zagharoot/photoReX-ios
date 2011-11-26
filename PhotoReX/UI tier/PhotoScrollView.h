//
//  PhotoScrollView.h
//  rlimage
//
//  Created by Ali Nouri on 10/26/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIScrollView
{
    UIView* _imageView; 
    
}

@property (nonatomic, retain) UIView* imageView; 

@end
