//
//  PhotoViewController.m
//  flickrExcersize
//
//  Created by Ali Nouri on 5/16/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "PhotoViewController.h"
#import "AccountManager.h"
#import "ImageDataProviderManager.h" 
#import "AppDelegate.h"
#import "UIImage+StackBlur.h"

@implementation PhotoViewController
@synthesize commentBtnPressed;

@synthesize pictureInfo=_pictureInfo; 
@synthesize websiteIconImageView;
@synthesize closeBtn;
@synthesize navBar = _navBar;
@synthesize scrollView=_scrollView; 
@synthesize detailOverlayView=_detailOverlayView; 
@synthesize imageTitleLabel;
@synthesize imageAuthorLabel;
@synthesize imageNumberOfVisitsLabel;
@synthesize favoriteBtnTB;
@synthesize rotateBtnTB;
@synthesize shareBtnTB;
@synthesize commentBtnTB;
@synthesize floatingRotateBtn;
@synthesize blurredImageView=_blurredImageView; 

- (IBAction)dismissView:(id)sender 
{    
    imageView.delegate = nil;       
    [self dismissModalViewControllerAnimated:YES]; 
}


-(UIImageView*) blurredImageView
{
    if (_blurredImageView)
        return _blurredImageView; 
    
    
    _blurredImageView = [[UIImageView alloc] initWithFrame:imageView.frame]; 
    
    [_blurredImageView setHidden:YES];  
    _blurredImageView.alpha = 0.0; 
    
    [self.scrollView addSubview:_blurredImageView]; 
    
    return _blurredImageView; 
}

//this is the designated initializer 
-(id) initWithPictureInfo:(PictureInfo *)pic 
{
    self = [super initWithNibName:@"PhotoViewController" bundle:[NSBundle mainBundle]]; 
    if (self) 
    {
        self.pictureInfo = pic; 
    
        //some initializations
        self.wantsFullScreenLayout = YES;
        doubleTapFlag = NO; 
    }
    
    
    return self; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return nil; //only use initWithPictureInfo
}

- (void)dealloc
{
    [_pictureInfo release]; 
    [imageView release];
    [_blurredImageView release]; 
    [_navBar release];
    [closeBtn release];
    [websiteIconImageView release];
    [imageTitleLabel release];
    [imageAuthorLabel release];
    [imageNumberOfVisitsLabel release];
    [favoriteBtnTB release];
    [rotateBtnTB release];
    [shareBtnTB release];
    [commentBtnTB release];
    [floatingRotateBtn release];
    [commentBtnPressed release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view insertSubview:self.detailOverlayView belowSubview:self.floatingRotateBtn]; 
    [self.view insertSubview:self.scrollView belowSubview:self.detailOverlayView]; 
    
    [self.detailOverlayView setHidden:YES]; 
    self.detailOverlayView.pictureInfo = self.pictureInfo; 

  
    //TODO: depending on the device, we should modify this
    CGRect myFrame = CGRectMake(0, 0, 320, 320); 
    
    
    //initialize the image we want to show 
    imageView = [[UINetImageView alloc] initWithPictureInfo:self.pictureInfo andFrame:myFrame shouldClipToBound:NO drawUserActivity:NO]; 
    imageView.delegate = self; 
    self.scrollView.delegate = self; 
         
    self.scrollView.imageView = imageView;              //this adds the image to the scroll view 
    self.scrollView.contentSize = myFrame.size;         //once the image is available, we update this
    

    UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captureOneTouchTap:)]; 
    
    gr.numberOfTapsRequired = 1; 
    [self.scrollView addGestureRecognizer:gr]; 
    [gr release];     
    
    
    //start getting orientation change notification
    deviceGeneratedOrientationNotificationFlag =  [UIDevice currentDevice].isGeneratingDeviceOrientationNotifications; 

    if (! deviceGeneratedOrientationNotificationFlag)
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondToOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil]; 
    
    //defaults: 
    didAutoOrientationChange = NO; 
    didUserHateAutoOrientationChange = NO; 
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:self.navBar]; 
    self.closeBtn.title = @"Cancel"; 
}


-(void) showRotateButton
{
    
    CGRect b = self.view.bounds; 
    self.floatingRotateBtn.frame = CGRectMake(b.size.width-50-27, b.size.height-50-26, 27, 26); 
    
    self.floatingRotateBtn.alpha = 0.0; 
    self.floatingRotateBtn.hidden = NO; 
    
    [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationCurveEaseInOut animations:^{
        self.floatingRotateBtn.alpha = 1.0; 
    }//animation
    completion:^(BOOL finished) {
        [self performSelector:@selector(hideRotateButton) withObject:self afterDelay:6.0]; 
    }];
}

-(void) hideRotateButton{ [self hideRotateButtonAnimation:YES]; } 


- (IBAction)commentBtnPressed:(id)sender {
    [self blurTheImage:self.blurredImageView.hidden];  
}

- (IBAction)sharePressed:(id)sender {

    [self blurTheImage:self.blurredImageView.hidden];  
}


-(void) blurTheImage:(BOOL)blur{
    
    if (! self.blurredImageView.image)
        blur = NO; 
    

    [UIView animateWithDuration:0.2 animations:^{
        if (blur)
            self.blurredImageView.hidden = !blur; 
        self.blurredImageView.alpha = (double) blur; 
        self.detailOverlayView.isModalVisible = blur; 
        self.imageTitleLabel.hidden = blur; 
        self.imageAuthorLabel.hidden = blur; 
        self.imageNumberOfVisitsLabel.hidden = blur; 
        self.websiteIconImageView.hidden = blur; 
        
        self.detailOverlayView.isModalVisible = blur; 
        
    } completion:^(BOOL fin){
        if (!blur)
            self.blurredImageView.hidden = !blur; 
    }];
    
    if (self.blurredImageView.image && blur ) 
        [self.blurredImageView setFrame:imageView.frame]; 
    
}





-(void) hideRotateButtonAnimation:(BOOL)animated
{
    if (!animated)
    {
        self.floatingRotateBtn.hidden = YES; 
        return; 
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.floatingRotateBtn.alpha = 0.0; 
    }completion:^(BOOL finished) {
        self.floatingRotateBtn.hidden = YES; 
    }]; 
}



- (void)viewDidUnload
{
    self.pictureInfo = nil; 
    [imageView release]; 
    [_blurredImageView release]; 

    
    //turn notification generation if noone is using it
    if (! deviceGeneratedOrientationNotificationFlag)
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
    
    [self setNavBar:nil];
    [self setCloseBtn:nil];
    [self setWebsiteIconImageView:nil];
    [self setImageTitleLabel:nil];
    [self setImageAuthorLabel:nil];
    [self setImageNumberOfVisitsLabel:nil];
    [self setFavoriteBtnTB:nil];
    
    
    [self setRotateBtnTB:nil];
    [self setShareBtnTB:nil];
    [self setCommentBtnTB:nil];
    [self setFloatingRotateBtn:nil];
    [self setCommentBtnPressed:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) respondToOrientationChange
{

    //picture is locked because we auto rotated and he hasn't counter acted it. 
    if (didAutoOrientationChange && !didUserHateAutoOrientationChange)
        return; 
    
    enum UserOrientation userOrientation =  ((AppDelegate*) [UIApplication sharedApplication].delegate).userOrientation; 
    UIDeviceOrientation orientation      =  [UIDevice currentDevice].orientation; 
    double degree = 0; 
    
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            
            if (userOrientation == UserOrientationStanding || userOrientation == UserOrientationUnknown)
                degree = M_PI_2; 
            break;
        case UIDeviceOrientationLandscapeRight:
            if (userOrientation == UserOrientationStanding || userOrientation == UserOrientationUnknown)
                degree = -M_PI_2; 
            
            break;
        default:
            break;
    }


    [self rotatePictureToDegree:degree]; 
}


-(void) rotatePictureToDegree:(double)degree
{
    CGAffineTransform transform = CGAffineTransformMakeRotation(degree); 
    
    //no need to do anything 
    if (CGAffineTransformEqualToTransform(transform, self.scrollView.transform))
        return; 
    
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.transform = transform; 
    }]; 

    //correct the bounds 
    CGSize b = self.scrollView.bounds.size; 
    if (degree==0 && b.width > b.height)                                //portrait mode
        self.scrollView.bounds = CGRectMake(0, 0, b.height, b.width); 
    else if (degree!= 0 && b.width < b.height)                          //landscape mode 
        self.scrollView.bounds = CGRectMake(0, 0, b.height, b.width); 
    
    
    //change the image of the toolbar button 
    if (degree != 0)
        [self.rotateBtnTB setBackgroundImage:[UIImage imageNamed:@"rotateToPortrait.png"] forState:UIControlStateNormal ]; 
    else
        [self.rotateBtnTB setBackgroundImage:[UIImage imageNamed:@"rotateToLandscape.png"] forState:UIControlStateNormal ]; 
    
    [self.rotateBtnTB setNeedsDisplay]; 
    
    //rezoom to fit the screen 
    self.scrollView.minimumZoomScale = 0.1; 
    [self.scrollView zoomToRect:defaultZoom animated:NO]; 
    self.scrollView.minimumZoomScale = self.scrollView.zoomScale; 
}

-(IBAction) rotatePictureToIdentityBySender:(UIButton *)sender
{

    [self rotatePictureToDegree:0]; 
    
    [self hideRotateButton]; 
    didUserHateAutoOrientationChange = YES; 
    

    //change the target action for the rotate buttons 
    [self.rotateBtnTB removeTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotateBtnTB addTarget:self action:@selector(rotatePictureToAutoBySender:) forControlEvents:UIControlEventTouchUpInside]; 
}


-(void) rotatePictureToAutoBySender:(UIButton *)sender
{
    double degree = M_PI_2; 
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) 
        degree = -M_PI_2; 

    [self rotatePictureToDegree:degree]; 
    
    didUserHateAutoOrientationChange = NO; 

    //change the target action for the rotate buttons 
    [self.rotateBtnTB removeTarget:self action:@selector(rotatePictureToAutoBySender:) forControlEvents:UIControlEventTouchUpInside]; 
    [self.rotateBtnTB addTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside];
    
}



-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView; 
}

-(void) captureOneTouchTap:(UITapGestureRecognizer*) sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (doubleTapFlag)  //this is a double tap
        {
            doubleTapFlag = NO; 
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleStatusbar) object:nil]; 
            [self toggleZoomToContentWithAnimation:YES]; 
        }else   //this is the first tap
        {
            if (self.blurredImageView.hidden)
            {    
                doubleTapFlag = YES; 
                [self performSelector:@selector(toggleStatusbar) withObject:nil afterDelay:0.35]; 
            }else
                [self blurTheImage:NO]; 
        }
    }
}


-(void) toggleStatusbar
{
    doubleTapFlag = NO; 

    
    BOOL curVal =  [UIApplication sharedApplication].statusBarHidden; 

    [UIApplication sharedApplication].statusBarHidden = !curVal; 
//    self.navBar.hidden = !curVal;  
    [self.detailOverlayView setHidden:!curVal]; 
    
    if (curVal)
    {
        self.imageTitleLabel.text = self.pictureInfo.info.title; 
        self.imageAuthorLabel.text = [NSString stringWithFormat:@"By %@", self.pictureInfo.info.author]; 
        if ([self.pictureInfo.info respondsToSelector:@selector(numberOfVisits) ])
            self.imageNumberOfVisitsLabel.text = [NSString stringWithFormat:@"Viewed %d times", [self.pictureInfo.info performSelector:@selector(numberOfVisits)] ]; 
        
        [self hideRotateButtonAnimation:NO]; 
        
    }
}

-(void) hideStatusBar
{
    [UIApplication sharedApplication].statusBarHidden = YES;     
//    self.navBar.hidden = YES;  
    [self.detailOverlayView setHidden:YES]; 
}

-(void) imageBecameAvailableForView:(UINetImageView *)view
{
    [self hideStatusBar]; 
    [self.navBar setHidden:YES]; 
    self.closeBtn.title = @"Close"; 
    

    
    CGSize windowSize = self.scrollView.bounds.size; //  [[UIScreen mainScreen] applicationFrame].size; 
    
    
    CGRect frame = view.frame; 
    CGSize size = frame.size; 


    if (view.imageOrientation == UIInterfaceOrientationLandscapeRight ) //image is landscape 
    {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) 
            self.scrollView.transform = CGAffineTransformMakeRotation(-M_PI_2); 
        else
            self.scrollView.transform = CGAffineTransformMakeRotation(M_PI_2); 

        self.scrollView.bounds = CGRectMake(0, 0, self.scrollView.bounds.size.height, self.scrollView.bounds.size.width); 
        didAutoOrientationChange = YES; 

        
        [self.rotateBtnTB setBackgroundImage:[UIImage imageNamed:@"rotateToPortrait.png"] forState:UIControlStateNormal ]; 
        
        //let user know about the auto rotate by the optional rotate back button
        [self showRotateButton]; 
    }
    
    
    if (size.width<windowSize.width)
    {
        size.width = windowSize.width; 
    }
    
    
    if (size.height<windowSize.height)
    {
        size.height = windowSize.height; 
        
    }
    
    //update content size 
    self.scrollView.contentSize = size; 

    self.scrollView.minimumZoomScale = 0.1; 
    self.scrollView.maximumZoomScale = 3.0; 

    defaultZoom = frame; 
    [self toggleZoomToContentWithAnimation:NO]; 

    
    
    
    //set the original zoom scale
    originalZoom = 1.0; 
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
    {
        //we have retina display. set zoom level to 0.5 (hopefullY) so we still have sharp image even when zoomed in. 
        double wzoom = self.scrollView.bounds.size.width / size.width; 
        double hzoom = self.scrollView.bounds.size.height / size.height; 
        originalZoom = MAX( 0.75, MAX(wzoom, hzoom)); 
    }    

    
    //make the blurred version of the image in a separate thread so it doesn't block 
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.blurredImageView.image = [imageView.image stackBlur:30]; 
        }
        @catch (NSException *exception) {
        }
    }); 
    
    
    self.scrollView.minimumZoomScale = self.scrollView.zoomScale; 
    
    //change the status of the pictureInfo 
    [self.pictureInfo makeViewed]; 
    
    
    //set the detail description of the im
    Account* acc = [AccountManager getAccountFromPictureInfo:self.pictureInfo]; 
    [self.websiteIconImageView setImage:acc.iconImage]; 
    [self.websiteIconImageView sizeToFit]; 


    //----- set up toolbar buttons based on the picture 
    //favorite button: 
    if (acc.isActive && [acc supportsFavorite])
    {
        [self.favoriteBtnTB setHidden:NO]; 
        if (self.pictureInfo.info.isFavorite)
            [self.favoriteBtnTB setImage:[UIImage imageNamed:@"favoriteBtnSelected.png"] forState:UIControlStateNormal]; 
        else
            [self.favoriteBtnTB setImage:[UIImage imageNamed:@"favoriteBtn.png"] forState:UIControlStateNormal]; 
        
    }
    else 
        [self.favoriteBtnTB setHidden:YES]; 
    
    //rotate button
    self.rotateBtnTB.hidden = !didAutoOrientationChange; 
    [self.rotateBtnTB removeTarget:self action:@selector(rotatePictureToAutoBySender:) forControlEvents:UIControlEventTouchUpInside]; 
    [self.rotateBtnTB addTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside];
    
    //share button: it's always available?
    self.shareBtnTB.hidden = NO; 
    
    //comment button: it's invisible for now
    self.commentBtnTB.hidden = NO;

}


-(void) toggleZoomToContentWithAnimation:(BOOL)animation
{
    if (defaultZoom.size.width ==0)         //don't know what the fit-image bound is yet
        return; 
        
    if (self.scrollView.zoomScale == originalZoom || self.scrollView.zoomScale ==1.0)    
        [self.scrollView zoomToRect:defaultZoom animated:animation]; 
    else
        self.scrollView.zoomScale = originalZoom; 
    
}


- (IBAction)toggleFavorite:(id)sender 
{

    ImageDataProviderManager* provider = [ImageDataProviderManager mainDataProvider]; 
    if (self.pictureInfo.info.isFavorite)
    {
        [self.favoriteBtnTB setImage:[UIImage imageNamed:@"favoriteBtn.png"] forState:UIControlStateNormal]; 
        [provider setFavorite:NO forPictureInfo:self.pictureInfo]; 
    }else 
    {
        [self.favoriteBtnTB setImage:[UIImage imageNamed:@"favoriteBtnSelected.png"] forState:UIControlStateNormal]; 
        [provider setFavorite:YES forPictureInfo:self.pictureInfo]; 
    }
}
@end
