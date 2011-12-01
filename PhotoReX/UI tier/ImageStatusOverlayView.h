//
//  ImageStatusOverlayView.h
//  photoRexplore
//
//  Created by Ali Nouri on 11/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//


#import <UIKit/UIKit.h>


@class PictureInfo; 

//This class provides a way to show different status flags on an image icon (used for grid view only) 

@interface ImageStatusOverlayView : UIView
{
    PictureInfo* pictureInfo; 
}

-(id) initWithPictureInfo:(PictureInfo*) p andParentFrame:(CGRect) frame; 

@end

