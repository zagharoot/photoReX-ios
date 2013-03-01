//
//  ImageGridUIViewController.m
//  rlimage
//
//  Created by Ali Nouri on 7/10/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "ImageGridUIViewController.h"
#import "PhotoViewController.h"
#import "FancyTabbarController.h" 
#import "ErrorViewController.h"
#import "TestViewController.h"
#import "NSError+Util.h"
#import "PagedNavigatorController.h" 

#define EDGE_PADDING    13                      //the space around the pictures to the edge of the frame
#define PICTURE_PADDING  8         //the space between pictures specified in percentage of the pic width



@implementation ImageGridUIViewController
@synthesize imageSource   = _imageSource; 
@synthesize delegate=_delegate; 


-(void) setImageSource:(PictureInfoCollection *)imageSource
{
    if (_imageSource)
        _imageSource.delegate = nil; 
    
    _imageSource = [imageSource retain]; 
    
    _imageSource.delegate = self; 
}


-(void) setup
{
    numberOfRows = 4; 
    numberOfColumns = 2;

    [self loadImages]; 
}
                
-(void) dealloc
{
    if (_alwaysShowStatusBand)
        [_alwaysShowStatusBand release];
    
    [super dealloc];
}


//returns true if we always show the info band on the pictures. 
-(BOOL) alwaysShowStatusBand
{
    if (_alwaysShowStatusBand)
        return _alwaysShowStatusBand.boolValue;
    
    //this is the first time. get it from the settings
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    _alwaysShowStatusBand = [[NSNumber alloc] initWithBool:[userDefaults boolForKey:@"alwaysShowInfoBand"]];
    return _alwaysShowStatusBand.boolValue;
}


-(void) loadImages 
{
    if (self.imageSource.errorMessage)
    {
//        ErrorViewController* evc = [[[ErrorViewController alloc] initWithErrorMessage:self.imageSource.errorMessage] autorelease]; 
        
//        [self addChildViewController:evc]; 
//        [self.view addSubview:evc.view]; 
        
        [self.imageSource.errorMessage show]; 
        
        [self showErrorButtons]; 
        return; 
    }
    
    
    for(int i=0; i < numberOfRows*numberOfColumns; i++)
    {
        PictureInfo* pictureInfo = [self.imageSource getPictureInfoAtLocation:i]; 
        CGPoint pos = [self getRowAndColFromIndex:i]; 
        CGRect frame = [self getPictureFrameAtPosition:pos]; 
        UINetImageView* img = [[UINetImageView alloc] initWithPictureInfo:pictureInfo andFrame:frame shouldClipToBound:YES drawUserActivity:YES isFullScreen:NO];
//        img.drawUserActivityStatus = YES; 
        
        img.imageStatusOverlayView.alwaysShow = [self alwaysShowStatusBand];
        
        
        UIImageButton* btn = [[UIImageButton alloc] initWithImage:img]; 
        [btn addTarget:self action:@selector(showImageDetail:) forControlEvents:UIControlEventTouchUpInside]; 
        
        [self.view addSubview:btn];        
        [img release];                  //the array has a retain on it, so we are good
        [btn release]; 
    }
}


-(void) setPage:(int)page
{
    _page = page; 
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
    // Do any additional setup after loading the view from its nib.
    
    [self setup]; 
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.imageSource = nil;             //don't do [_imageSource release] because we've overriden the setter func
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(CGSize) getPictureSize
{
    CGFloat totalWidth =  self.pageSize.width; // self.view.bounds.size.width;
    CGFloat totalHeight = self.pageSize.height; //self.view.bounds.size.height;
    
    CGSize result; 
    result.width = (totalWidth - 2*EDGE_PADDING) - (numberOfColumns-1)*PICTURE_PADDING; 
    result.height = (totalHeight - 2*EDGE_PADDING)- (numberOfRows-1)*PICTURE_PADDING; 
    
    
    result.width = result.width / (numberOfColumns); 
    result.height = result.height / (numberOfRows); 
    
    
//    printf("pic size %f, %f\n", result.width, result.height);
    
    return result; 
}

// the pos starts at (0,0) on top left and moves toward right down
-(CGPoint) getRowAndColFromIndex:(int)index
{
    CGPoint result; 
    
    result.y = index / numberOfColumns; 
    result.x = index % numberOfColumns; 
    
    return result; 
}

-(CGRect) getPictureFrameAtPosition:(CGPoint)pos
{
    return [self getPictureFrameAtRow:pos.y andCol:pos.x]; 
}

-(CGRect) getPictureFrameAtRow:(int)row andCol:(int)col
{
    CGRect result; 
    CGSize theSize = [self getPictureSize]; 

    CGPoint origin; 
    origin.x = EDGE_PADDING + col*PICTURE_PADDING + (col)*theSize.width; 
    origin.y = EDGE_PADDING + row*PICTURE_PADDING + (row)*theSize.height ;
    
    result = CGRectMake(origin.x, origin.y, theSize.width, theSize.height); 
    
    return result; 
    
}


-(void) showImageDetail:(UIImageButton *)imgBtn
{    
    //if the image has failed, try to reload it insead of showing the details 
    if (imgBtn.imageView.failedToLoad)
    {
        [imgBtn.imageView loadPicture]; 
        return; 
    }
    
    
    
    
    PhotoViewController* pvc = [[[PhotoViewController alloc] initWithPictureInfo:imgBtn.imageView.pictureInfo]  autorelease]; 
    
    pvc.modalPresentationStyle = UIModalPresentationFullScreen; 
    pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    
    //present the picture modally using the tabbar (the root of all view controllers, so nothing intercepts) 
    [[FancyTabbarController getInstance] presentViewController:pvc animated:YES completion:nil];  
 //   [self presentModalViewController:pvc animated:YES]; 
    
    
    if (self.delegate)
        if ([self.delegate respondsToSelector:@selector(imageAtIndex:selectedInPictureInfoCollection:)])
        {
            int indx = [self.imageSource getIndexOfPictureInfo:imgBtn.imageView.pictureInfo]; 
            [self.delegate imageAtIndex:indx  selectedInPictureInfoCollection:self.imageSource]; 
        }
}


-(void) imageSignaturesFailedToReceive:(NSError *)err
{
    //remove all the images if already added to the view 
    NSArray* arr = [NSArray arrayWithArray:self.view.subviews]; 
    for (UIView* v in arr) {
        [v removeFromSuperview]; 
    }
    
    [self showErrorButtons]; 
    [err show]; 
}


-(void) showErrorButtons
{
    if (! refreshBtn)
    {
        refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
        [refreshBtn setBackgroundImage:[UIImage imageNamed:@"shareBtn.png"] forState:UIControlStateNormal]  ; 
        [refreshBtn sizeToFit]; 
    }
    
    if (! errorBtn)
    {
        errorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [errorBtn setBackgroundImage:[UIImage imageNamed:@"dropdown-alert.png"] forState:UIControlStateNormal]  ; 
        [errorBtn sizeToFit]; 
    }
    
    
    [self.view addSubview:refreshBtn]; 
    [self.view addSubview:errorBtn]; 
    
    CGPoint p = self.view.center; 
    refreshBtn.center = CGPointMake(p.x - 20, p.y); 
    errorBtn.center = CGPointMake(p.x+20,p.y); 
    
    [errorBtn addTarget:self action:@selector(showError) forControlEvents:UIControlEventTouchDown]; 
    [refreshBtn addTarget:self action:@selector(regetPictures) forControlEvents:UIControlEventTouchDown]; 
    
}


-(void) hideErrorButtons
{
    [refreshBtn removeFromSuperview]; 
    [errorBtn removeFromSuperview]; 
    
    [refreshBtn release]; 
    [errorBtn release]; 
    
}

-(void) regetPictures
{
    self.imageSource = [self.provider.contentProvider getContentAtPage:self.page];
}

-(void) showError
{
    if (self.imageSource.errorMessage)
        [self.imageSource.errorMessage show]; 
}

@end
