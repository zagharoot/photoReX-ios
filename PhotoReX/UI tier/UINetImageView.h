//
//  UINetImageView.h
//  rlimage
//
//  Created by Ali Nouri on 7/20/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureInfo.h"
#import "ImageDataProviderManager.h"
#import "UnavailableImageHandler.h"
#import "ImageStatusOverlayView.h"

@class UINetImageView; 

@protocol UINetImageViewDelegate <NSObject>

-(void) imageBecameAvailableForView:(UINetImageView*) view; 

@end

//This class provides an abstract form of UIImage that can get the content of the image from the net
@interface UINetImageView : UIImageView <DataDownloadObserver>
{

    PictureInfo* _pictureInfo; 
    CGSize _originalResolution;             //this is the resolution of the picture coming from the net. (0,0) means don't have the data yet.
    
    
    
    UnavailableImageHandler* _unavailableImageHandler; 
    ImageStatusOverlayView* _imageStatusOverlayView; 
    
    id <UINetImageViewDelegate> _delegate; 
        
    BOOL _clipToBound; 
    BOOL _drawUserActivityStatus; 
    double _percentageDataAvailable;
    BOOL _isFullScreen;
    UIImage* _tmpImage;                 //this is just because we want to delay becomeAvailable
    
    NSTimeInterval loadStartTime;               //time we started loading the image; 
}

-(id) initWithPictureInfo:(PictureInfo*) pictureInfo andFrame:(CGRect) frame; 
-(id) initWithPictureInfo:(PictureInfo *)pictureInfo andFrame:(CGRect) frame shouldClipToBound:(BOOL) clip drawUserActivity:(BOOL) activity isFullScreen:(BOOL) full;
-(void) loadAsUnavailableImage; 
-(void) loadPicture; 
-(BOOL) isPictureAvailable;             //returns true if the image is already downloaded and ready

// get updates from the picture info 
-(void) imageActivityStatusDidChange:(NSNotification*) notification; 
-(void) imageDataDidChange:(NSNotification*) notification; 
-(void) becomeAvailable; 



@property (readonly) CGSize originalResolution; 
@property (retain) PictureInfo* pictureInfo; 
@property (nonatomic, assign) id<UINetImageViewDelegate> delegate; 
@property (nonatomic) BOOL clipToBound; 
@property (nonatomic) BOOL drawUserActivityStatus; 
@property (nonatomic, readonly) double percentageDataAvailable; 
@property (nonatomic, retain) UnavailableImageHandler* unavailableImageHandler; 
@property (nonatomic, readonly) ImageStatusOverlayView* imageStatusOverlayView; 
@property (nonatomic, retain) UIImage* tmpImage;
@property (nonatomic) BOOL isFullScreen; 

@property (nonatomic, readonly) UIInterfaceOrientation imageOrientation; 



@property (nonatomic, readonly) BOOL failedToLoad; 
@end



