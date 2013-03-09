//
//  GraphWalkUIViewController.m
//  photoReX
//
//  Created by Ali Nouri on 3/3/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "GraphWalkUIViewController.h"
#import "AppDelegate.h"
#import "PageIndicatorHUDView.h"

@interface GraphWalkUIViewController ()

@end

@implementation GraphWalkUIViewController
@synthesize root=_root;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return nil;
}

-(id) initWithRoot:(GraphNode*) root andFrame:(CGRect)frame
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.root = root;

        GraphWalkView* page = [[[GraphWalkView alloc] initWithNode:self.root andFrame:frame] autorelease];
        
        pages = [[NSMutableArray alloc] initWithCapacity:5];
        [pages addObject:page];
        //    self.scrollView.contentSize = CGSizeMake(wSize.width, wSize.height);
        //    [self.scrollView addSubview:page];

        
        CGRect mainNodeFrame = CGRectMake(50, 50, 100, 100);
        GraphNodeImageView* mainPigImageView = [[GraphNodeImageView alloc] initWithPictureInfo:self.root.picInfo andFrame:mainNodeFrame];
        
        
        [self.view addSubview:mainPigImageView];
    
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    return; 
    
    CGSize wSize  = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).windowSize;
    CGRect frame = CGRectMake(0, 0 , wSize.width, wSize.height);

//    self.view.frame = frame;
//    [self.view addSubview:self.scrollView];
    
    PageIndicatorHUDView* pv = [[PageIndicatorHUDView alloc] initWithFrame:frame];
    pv.totalPage = 10;
    pv.currentPage = 7;

    
    
    GraphWalkView* page = [[[GraphWalkView alloc] initWithNode:self.root andFrame:frame] autorelease];
    
    pages = [[NSMutableArray alloc] initWithCapacity:5];
    [pages addObject:page];
//    self.scrollView.contentSize = CGSizeMake(wSize.width, wSize.height);
//    [self.scrollView addSubview:page];
    self.view = page; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidUnload
{
    [self setScrollView:nil];
    [self setScrollView:nil];
    [pages release];
    
}




-(void) expand:(GraphNode *)parent withChild:(GraphNode *)child atPage:(int)p
{
    
    // should remove all the pages after this node
    int cnt = pages.count;
    for(int i=cnt-1; i>= p+1; i--)
    {
        //remove content from scrollview
        GraphWalkView* view = (GraphWalkView*) [pages objectAtIndex:i];
        [view removeFromSuperview];

        //remove from array
        [pages removeLastObject];
    }

    
    //now expand the item
    
    GraphWalkView* childView = [[GraphWalkView alloc] initWithNode:child];
    childView.page = pages.count;
    
    
    
    CGSize wSize  = ((AppDelegate*) [[UIApplication sharedApplication] delegate]).windowSize;
    CGRect frame = CGRectMake(0, p*wSize.height  , wSize.width, wSize.height);
    childView.frame = frame;
    
    [pages addObject:childView];
    [self.scrollView addSubview:childView];
}





- (void)dealloc {
    [_scrollView release];
    [_scrollView release];
    [super dealloc];
}
@end
