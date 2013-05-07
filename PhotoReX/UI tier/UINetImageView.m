//
//  UINetImageView.m
//  rlimage
//
//  Created by Ali Nouri on 7/20/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "UINetImageView.h"
#import "AccountManager.h"
#import "ImageDataProviderManager.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


@implementation UINetImageView

@synthesize originalResolution=_originalResolution; 
@synthesize pictureInfo=_pictureInfo; 
@synthesize delegate=_delegate; 
@synthesize clipToBound=_clipToBound; 
@synthesize drawUserActivityStatus=_drawUserActivityStatus; 
@synthesize percentageDataAvailable=_percentageDataAvailable; 
@synthesize unavailableImageHandler=_unavailableImageHandler; 
@synthesize tmpImage=_tmpImage; 
@synthesize isFullScreen=_isFullScreen;


-(UIInterfaceOrientation) imageOrientation
{
    if (self.bounds.size.width > self.bounds.size.height)
        return UIInterfaceOrientationLandscapeRight; 
    else
        return UIInterfaceOrientationPortrait; 
}

-(BOOL) failedToLoad
{
    return self.percentageDataAvailable <0;         //we set it to -1 when error occurs
}

-(ImageStatusOverlayView*) imageStatusOverlayView
{
    if (! _imageStatusOverlayView)
    {
        _imageStatusOverlayView = [[ImageStatusOverlayView alloc] initWithPictureInfo:self.pictureInfo andParentFrame:self.frame];
        _imageStatusOverlayView.alpha = 0.0;            //initially it's invisible until the actual data arrives 
        [self addSubview:_imageStatusOverlayView]; 
    }

    return _imageStatusOverlayView; 
}

-(void) setDrawUserActivityStatus:(BOOL)drawUserActivityStatus
{
    _drawUserActivityStatus = drawUserActivityStatus; 
    if (drawUserActivityStatus)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageActivityStatusDidChange:) name:@"PictureInfoImageActivityStatusDidChange" object:self.pictureInfo]; 
    else
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PictureInfoImageActivityStatusDidChange" object:self.pictureInfo]; 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _drawUserActivityStatus = NO;       //this is the default (dont use the property here, look at set)
        _percentageDataAvailable = 0;       //no data is available yet
        
        _isFullScreen = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"in draw rect"); 
    [super drawRect:rect]; 
 
    //draw progress bar indicator 
    if(self.percentageDataAvailable>=0 &&  self.percentageDataAvailable < 1.0)
    {
        [self.unavailableImageHandler drawRect:rect]; 
    }

}
*/


#pragma -mark pictureInfo delegate functions 

-(void) imageDataDidChange:(NSNotification*) notification 
{
    [self loadPicture]; 
}


-(void) imageActivityStatusDidChange:(NSNotification*) notification
{
    if (! self.drawUserActivityStatus)
        return; 
    
    //TODO: do something else 
/*    
    switch (self.pictureInfo.userActivityStatus) {
        case ImageActivityStatusVisited:
            self.layer.borderWidth = 3; 
            break;
            
        default:
            self.layer.borderWidth = 0; 
            break;
    }
    
    self.layer.borderColor = [UIColor whiteColor].CGColor; 
    
    [self setNeedsDisplay]; 
*/
    
    if (self.imageStatusOverlayView)
        [self.imageStatusOverlayView setNeedsDisplay]; 
}


-(id) initWithPictureInfo:(PictureInfo*)pictureInfo andFrame:(CGRect) frame
{
    return [self initWithPictureInfo:pictureInfo andFrame:frame shouldClipToBound:YES drawUserActivity:NO isFullScreen:NO];
}


-(id) initWithPictureInfo:(PictureInfo *)pictureInfo andFrame:(CGRect) frame shouldClipToBound:(BOOL) clip drawUserActivity:(BOOL)activity isFullScreen:(BOOL) full
{
    self = [self initWithFrame:frame]; 
    if (!self)
        return nil; 
 
    self.clipToBound = clip; 
    self.pictureInfo = pictureInfo; 
    self.drawUserActivityStatus = activity;
    self.isFullScreen = full; 
    
    //register to the notification center to receive updates for this object 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDataDidChange:) name:@"PictureInfoImageDataDidChange" object:pictureInfo]; 
    
    //until the image is fully downloaded, have a decent picture in place
    [self loadAsUnavailableImage]; 

    if ([pictureInfo isInfoDataAvailable])          //if not, we'll get notified as its delegate
        [self loadPicture]; 

    return self; 
}


//just to make code cleaner: it tries to download the picture based on the pictureInfo
-(void) loadPicture
{
//    NSLog(@"loading picture ------\n"); 
    
    _percentageDataAvailable = 0;           //no data for this image is received yet!
    
    loadStartTime = [[NSDate date] timeIntervalSince1970]; 
    
    [[ImageDataProviderManager mainDataProvider] getDataForPicture:self.pictureInfo withResolution:[PictureInfo CGSizeToImageResolution:self.frame.size] withObserver:self]; 

    
    [self imageActivityStatusDidChange:nil]; 
    [self.unavailableImageHandler setNeedsDisplay]; 
 }


//initializes and displays a default picture indicating the image is not still available
-(void) loadAsUnavailableImage
{
    
    if (self.isFullScreen)
        self.unavailableImageHandler = [[[UnavailableImageHandlerLandscape alloc] initWithImageView:self] autorelease]; 
    else
    {
        self.unavailableImageHandler = [[[UnavailableImageHandler4x3 alloc] initWithImageView:self] autorelease]; 
    }
//        self.image = [UINetImageView getUnavailableImage4x3]; 
  //  [self sizeToFit]; 

    
    
    self.unavailableImageHandler.frame = self.bounds; 
    [self addSubview:self.unavailableImageHandler]; 
    
}



-(void) dealloc
{
    self.pictureInfo = nil; 
    self.unavailableImageHandler = nil; 
    self.tmpImage = nil; 
    
    //remove nsnotification center observer 
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
    
    
    [super dealloc]; 
}



//try to release the static images that are cached for unavailable images
-(void) didReceiveMemoryWarning
{
    //this is fine because either someone is using this object in which case this code doesn't do anything, 
    // or if nobody is using it in which case we remove it. It will be recreated in the next call. 
}



-(void) percentDataBecameAvailable:(double)percentage
{
    _percentageDataAvailable = percentage; 
    
    
//    [self setNeedsDisplay]; 
    [self.unavailableImageHandler setNeedsDisplay]; 
    
 //   NSLog(@"received %lf percent of picture\n", percentage); 
}


-(void) imageFailedToLoad:(NSString *)reason
{
    _percentageDataAvailable = -1; 
}

-(void) imageDidBecomeAvailable:(UIImage *)theImage
{
    //TODO: remove this
//    [self imageFailedToLoad:@"alaki"]; 
//    return; 
    
    
    if (self.clipToBound)
    {
        //want to grab a clipping area from the picture. based on the size of the displayable area, we need to grab enough pixels from the actual image (taking into account that iphone4 can display two points per pixel). 
        
        
        CGRect r = self.bounds; 
        double factor = 2; 
        if (theImage.size.width < r.size.width*factor)
            factor = theImage.size.width / r.size.width; 
        
        if (theImage.size.height < r.size.height*factor)
            factor = theImage.size.height / r.size.height; 
        
        //select a bound from the middle of the image with the right factor 
        r.size.width *=factor; 
        r.size.height *=factor; 
        r.origin.x = (theImage.size.width - r.size.width)/2.0; 
        r.origin.y = (theImage.size.height - r.size.height)/2.0; 
        
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([theImage CGImage], r);
        
        // or use the UIImage wherever you like
        theImage = [UIImage imageWithCGImage:imageRef scale:factor orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
    } 
    
    
    
    self.tmpImage = theImage; 
    
    double loadDelay = 0; 
    if ([[NSDate date] timeIntervalSince1970] - loadStartTime > 0.8)
        loadDelay = 0.15; 
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:loadDelay target:self selector:@selector(becomeAvailable) userInfo:nil repeats:NO]; 
    
}

-(void) becomeAvailable
{
    [self.unavailableImageHandler removeFromSuperview]; 
    self.unavailableImageHandler = nil; 
    
    _percentageDataAvailable = 1.0; 
    self.unavailableImageHandler = nil; 
    
    
    [self setImage:self.tmpImage];
    self.tmpImage = nil; 
    
    if (self.clipsToBounds)
        [self sizeToFit];
    
    
    self.alpha = 0;                 
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationCurveLinear 
                     animations:^{self.alpha = 1.0;  } 
                     completion:^(BOOL fin) {} ]; 

    [self.delegate imageBecameAvailableForView:self];     

    
    if (self.drawUserActivityStatus)
        self.imageStatusOverlayView.alpha = 1.0; 
    
}

-(BOOL) isPictureAvailable
{
    return self.percentageDataAvailable >= 1.0; 
}


@end
