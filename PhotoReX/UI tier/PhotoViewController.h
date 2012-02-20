//
//  PhotoViewController.h
//  flickrExcersize
//
//  Created by Ali Nouri on 5/16/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureInfo.h" 
#import "UINetImageView.h"
#import "PhotoScrollView.h"
#import "PhotoDetailOverlayView.h" 

@interface PhotoViewController : UIViewController <UIScrollViewDelegate, UINetImageViewDelegate> {
    PictureInfo* _pictureInfo; 
    UINetImageView* imageView; 
    PhotoScrollView* _scrollView; 
    PhotoDetailOverlayView* _detailOverlayView; 
    
    CGRect defaultZoom;                 //the zoom that fits the entire image on page 
    CGFloat originalZoom;                //a zoom scale that doesn't rescale picture (should be 1 on device with no retina display)
    BOOL doubleTapFlag; 
    
    BOOL deviceGeneratedOrientationNotificationFlag;    //whether the notification was on before we load 
    BOOL didAutoOrientationChange;                      //whether we automatically changed the orientation of the picture 
    BOOL didUserHateAutoOrientationChange;              //true when auto change applied and user didn't like it (did rotation to counter act it)


}
@property (retain, nonatomic) IBOutlet UIBarButtonItem *closeBtn;

@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain, readonly) IBOutlet PhotoScrollView *scrollView;
@property (nonatomic, retain, readonly) IBOutlet PhotoDetailOverlayView* detailOverlayView; 
@property (retain, nonatomic) IBOutlet UILabel *imageTitleLabel;
@property (retain, nonatomic) IBOutlet UILabel *imageAuthorLabel;
@property (retain, nonatomic) IBOutlet UILabel *imageNumberOfVisitsLabel;
@property (retain, nonatomic) IBOutlet UIButton *favoriteBtnTB;
@property (retain, nonatomic) IBOutlet UIButton *rotateBtnTB;
@property (retain, nonatomic) IBOutlet UIButton *shareBtnTB;
@property (retain, nonatomic) IBOutlet UIButton *commentBtnTB;

@property (retain, nonatomic) IBOutlet UIButton *floatingRotateBtn;


- (IBAction)toggleFavorite:(id)sender;
@property (retain) PictureInfo* pictureInfo; 
@property (retain, nonatomic) IBOutlet UIImageView *websiteIconImageView;

- (IBAction)dismissView:(id)sender;
-(id) initWithPictureInfo:(PictureInfo*) pic;  
-(void) captureOneTouchTap:(UITapGestureRecognizer*) sender;
-(void) hideStatusBar; 
-(void)  toggleStatusbar;  //toggles between showing/hiding the statusbar and the title bar 
-(void) toggleZoomToContentWithAnimation:(BOOL) animation;  //toggles between zooming with scale 1.0 and picture-fit-screen scale

-(void) respondToOrientationChange; 
-(void) showRotateButton; 
-(void) hideRotateButton;       //automatically calls the animated one
-(void) hideRotateButtonAnimation:(BOOL) animated;
- (IBAction)rotatePictureToIdentityBySender:(UIButton *)sender;

//-(void) rotatePictureToIdentityBySender:(UIButton*) sender;            //undoes the auto rotate to original image orientation
-(void) rotatePictureToAutoBySender:(UIButton*) sender;                //automatically transforms the image to best fit the screen 
-(void) rotatePictureToDegree:(double) degree; 
@end
