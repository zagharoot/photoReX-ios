//
//  PhotoViewController.m
//  flickrExcersize
//
//  Created by Ali Nouri on 5/16/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@implementation PhotoViewController

@synthesize pictureInfo=_pictureInfo; 
@synthesize closeBtn;
@synthesize navBar = _navBar;
@synthesize scrollView=_scrollView; 


- (IBAction)dismissView:(id)sender {
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

/*    
    //move self under the statusbar 
    CGRect myFrame = [[UIScreen mainScreen] applicationFrame]; 
    myFrame.origin.y -= 20; 
    myFrame.size.height += 20; 
*/        
  
    //TODO: depending on the device, we should modify this
    CGRect myFrame = CGRectMake(0, 0, 320, 320); 
    
    
    //initialize the image we want to show 
    imageView = [[UINetImageView alloc] initWithPictureInfo:self.pictureInfo andFrame:myFrame shouldClipToBound:NO]; 
    imageView.delegate = self; 
    self.scrollView.delegate = self; 
         
    self.scrollView.imageView = imageView;              //this adds the image to the scroll view 
    self.scrollView.contentSize = myFrame.size;         //once the image is available, we update this
    

    UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captureOneTouchTap:)]; 
    
    gr.numberOfTapsRequired = 1; 
    [self.scrollView addGestureRecognizer:gr]; 
    [gr release]; 
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:self.navBar]; 
    self.closeBtn.title = @"Cancel"; 
}


-(void) viewDidAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
    self.pictureInfo = nil; 
    [imageView release]; 

    [self setNavBar:nil];
    [self setCloseBtn:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    self.navBar.hidden = !curVal;  
}

-(void) hideStatusBar
{
    [UIApplication sharedApplication].statusBarHidden = YES;     
    self.navBar.hidden = YES;  
}

-(void) imageBecameAvailableForView:(UINetImageView *)view
{
    [self hideStatusBar]; 
    self.closeBtn.title = @"Close"; 
    
    
    
    CGSize windowSize = [[UIScreen mainScreen] applicationFrame].size; 
    
    
    CGRect frame = view.frame; 
    CGSize size = frame.size; 


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


@end
