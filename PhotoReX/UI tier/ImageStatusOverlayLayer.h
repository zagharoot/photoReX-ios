//
//  ImageStatusOverlayLayer.h
//  photoRexplore
//
//  Created by Ali Nouri on 11/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class PictureInfo; 

//This class provides a way to show different status flags on an image icon (used for grid view only) 

@interface ImageStatusOverlayLayer : CALayer
{
    PictureInfo* pictureInfo; 
}

-(id) initWithPictureInfo:(PictureInfo*) p; 

@end
