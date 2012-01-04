//
//  UnavailableImageHandler.h
//  photoRexplore
//
//  Created by Ali Nouri on 11/24/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>


// This class (and its subclasses) handle the drawing of the image when the actual data is not fully downloaded yet. 
// It takes care of showing a temporary image as well as progress bar if desired

@class UINetImageView; 

@interface UnavailableImageHandler : UIView
{
    UINetImageView* _imageView; 
    
}

// a function to retrieve a UIImage for unavailable images (cached for fast retrieval and good memory management) 
-(UIImage*) getUnavailableImage; 

-(id) initWithImageView:(UINetImageView*) image; 
- (void)drawRect:(CGRect)rect; 

@property (nonatomic, assign) UINetImageView* imageView; 
@property (nonatomic) BOOL failedFlag; 
@end


//shows a landscape and responds to download progress 
@interface UnavailableImageHandlerLandscape : UnavailableImageHandler {
}

@end

//shows a simple image and doesn't respond to download progress
@interface UnavailableImageHandler4x3 : UnavailableImageHandler {
}

@end
