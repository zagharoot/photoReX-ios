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

#define EDGE_PADDING    13                      //the space around the pictures to the edge of the frame
#define PICTURE_PADDING  8         //the space between pictures specified in percentage of the pic width



@implementation ImageGridUIViewController
@synthesize imageSource   = _imageSource; 
@synthesize images = _images; 
@synthesize delegate=_delegate; 

-(void) setup
{
    numberOfRows = 4; 
    numberOfColumns = 3; 

    [self loadImages]; 
}
                
-(NSMutableArray*) images
{
    if (_images == nil)
        _images = [[NSMutableArray alloc] initWithCapacity:numberOfRows*numberOfColumns]; 
    
        return _images; 
}

-(void) loadImages 
{
    
    for(int i=0; i < numberOfRows*numberOfColumns; i++)
    {
        PictureInfo* pictureInfo = [self.imageSource getPictureInfoAtLocation:i]; 
        CGPoint pos = [self getRowAndColFromIndex:i]; 
        CGRect frame = [self getPictureFrameAtPosition:pos]; 
        UINetImageView* img = [[UINetImageView alloc] initWithPictureInfo:pictureInfo andFrame:frame shouldClipToBound:YES drawUserActivity:YES]; 
//        img.drawUserActivityStatus = YES; 
        
        UIImageButton* btn = [[UIImageButton alloc] initWithImage:img]; 
        [btn addTarget:self action:@selector(showImageDetail:) forControlEvents:UIControlEventTouchUpInside]; 
        
        [self.view addSubview:btn];        
        [self.images addObject:img]; 
        [img release];                  //the array has a retain on it, so we are good
        [btn release]; 
    }
}


-(void) setPage:(int)page
{
    _page = page; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.page = 1; 
        // Custom initialization
    }
    return self;
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
    
    self.imageSource = nil; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(CGSize) getPictureSize
{
    CGFloat totalWidth = self.view.bounds.size.width; 
    CGFloat totalHeight = self.view.bounds.size.height; 
    
    CGSize result; 
    result.width = (totalWidth - 2*EDGE_PADDING) - (numberOfColumns-1)*PICTURE_PADDING; 
    result.height = (totalHeight - 2*EDGE_PADDING)- (numberOfRows-1)*PICTURE_PADDING; 
    
    
    result.width = result.width / (numberOfColumns); 
    result.height = result.height / (numberOfRows); 
    
    
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
    origin.y = EDGE_PADDING + row*PICTURE_PADDING + (row)*theSize.height; 
    
    result = CGRectMake(origin.x, origin.y, theSize.width, theSize.height); 
    
    return result; 
    
}


-(void) showImageDetail:(UIImageButton *)imgBtn
{    
    PhotoViewController* pvc = [[[PhotoViewController alloc] initWithPictureInfo:imgBtn.imageView.pictureInfo]  autorelease]; 
    
    pvc.modalPresentationStyle = UIModalPresentationFullScreen; 
    pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    
    CGRect f = self.view.frame; 
    NSLog(@"cur page: (%f,%f) (%f,%f) \n", f.origin.x, f.origin.y, f.size.width, f.size.height); 

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
@end
