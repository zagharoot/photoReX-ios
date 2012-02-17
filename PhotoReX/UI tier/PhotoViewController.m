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

@implementation PhotoViewController

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


-(UIButton*) floatingRotateBtn
{
    if (! _floatingRotateBtn)
    {
        _floatingRotateBtn = [[UIButton alloc] initWithFrame:CGRectMake(200,300,36,36)]; 
        _floatingRotateBtn = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain]; 
        [self.view addSubview:_floatingRotateBtn];
        [_floatingRotateBtn addTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside]; 
        _floatingRotateBtn.hidden = YES; 
    }
    
    return _floatingRotateBtn; 
}


-(void) setFloatingRotateBtn:(UIButton *)floatingRotateBtn
{
    [_floatingRotateBtn removeFromSuperview]; 
    [_floatingRotateBtn release]; 
    _floatingRotateBtn = [floatingRotateBtn retain]; 
    
    [self.view addSubview:_floatingRotateBtn]; 
    _floatingRotateBtn.hidden = YES; 
}




- (IBAction)dismissView:(id)sender 
{    
    [self dismissModalViewControllerAnimated:YES]; 
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
    [_navBar release];
    [closeBtn release];
    [websiteIconImageView release];
    [imageTitleLabel release];
    [imageAuthorLabel release];
    [imageNumberOfVisitsLabel release];
    [favoriteBtnTB release];
    self.floatingRotateBtn = nil; 
    [rotateBtnTB release];
    [shareBtnTB release];
    [commentBtnTB release];
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

    [self.view addSubview:self.scrollView]; 
    [self.view addSubview:self.detailOverlayView]; 
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
    self.floatingRotateBtn.frame = CGRectMake(b.size.width-20-36, b.size.height-20-36, 36, 36); 
    
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
    
    [self setFloatingRotateBtn:nil]; 
    
    [self setRotateBtnTB:nil];
    [self setShareBtnTB:nil];
    [self setCommentBtnTB:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{   
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) respondToOrientationChange
{
//    [UIDevice currentDevice].orientation
    
    
}


-(void) rotatePictureToIdentityBySender:(UIButton *)sender
{
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.transform = CGAffineTransformIdentity; 
        self.scrollView.bounds = CGRectMake(0, 0, self.scrollView.bounds.size.height, self.scrollView.bounds.size.width); 
    }]; 

    [self hideRotateButton]; 
    
    didUserHateAutoOrientationChange = YES; 
 

    //change the target action for the rotate buttons 
    [self.rotateBtnTB removeTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotateBtnTB addTarget:self action:@selector(rotatePictureToAutoBySender:) forControlEvents:UIControlEventTouchUpInside]; 

    [self.floatingRotateBtn addTarget:self action:@selector(rotatePictureToAutoBySender:) forControlEvents:UIControlEventTouchUpInside]; 
    [self.floatingRotateBtn removeTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside];
}


-(void) rotatePictureToAutoBySender:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.4 animations:^{
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) 
            self.scrollView.transform = CGAffineTransformMakeRotation(-M_PI_2); 
        else
            self.scrollView.transform = CGAffineTransformMakeRotation(M_PI_2); 
            
        self.scrollView.bounds = CGRectMake(0, 0, self.scrollView.bounds.size.height, self.scrollView.bounds.size.width); 
    }]; 


    didUserHateAutoOrientationChange = NO; 

    //change the target action for the rotate buttons 
    [self.rotateBtnTB removeTarget:self action:@selector(rotatePictureToAutoBySender:) forControlEvents:UIControlEventTouchUpInside]; 
    [self.rotateBtnTB addTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.floatingRotateBtn removeTarget:self action:@selector(rotatePictureToAutoBySender:) forControlEvents:UIControlEventTouchUpInside]; 
    [self.floatingRotateBtn addTarget:self action:@selector(rotatePictureToIdentityBySender:) forControlEvents:UIControlEventTouchUpInside];
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
            doubleTapFlag = YES; 
            [self performSelector:@selector(toggleStatusbar) withObject:nil afterDelay:0.35]; 
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
        self.scrollView.transform = CGAffineTransformMakeRotation(M_PI_2); 
        self.scrollView.bounds = CGRectMake(0, 0, self.scrollView.bounds.size.height, self.scrollView.bounds.size.width); 
        didAutoOrientationChange = YES; 
        
        //TODO: let user know about the auto rotate by the optional rotate back button
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

    
    self.scrollView.minimumZoomScale = self.scrollView.zoomScale; 
    
    //change the status of the pictureInfo 
    [self.pictureInfo visit]; 
    
    
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
    self.commentBtnTB.hidden = YES;

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
