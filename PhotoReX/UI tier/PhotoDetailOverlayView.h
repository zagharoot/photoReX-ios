//
//  PhotoDetailOverlayView.h
//  photoReX
//
//  Created by Ali Nouri on 12/24/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureInfo.h" 

@interface PhotoDetailOverlayView : UIView
{
    CGGradientRef gradientRef; 
    
    PictureInfo* _pictureInfo; 
    
    BOOL _isModalVisible;            //whether one of the toolbar buttons (share, comments,...) is visible
}


@property (nonatomic, assign) PictureInfo* pictureInfo; 
@property (nonatomic) BOOL isModalVisible; 


@end
