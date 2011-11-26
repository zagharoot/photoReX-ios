//
//  PagedNavigatorController.m
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "PagedNavigatorController.h"

@implementation PagedNavigatorController
@synthesize contentProvider=_contentProvider; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //not using nib file
    return nil; 
}

-(id) initWithContentProvider:(id<PagedContentProvider>)provider
{
    self = [super initWithNibName:nil bundle:nil]; 
    if (self)
    {
        self.contentProvider = provider; 
    }
    
    return self; 
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL) needsEntirePage
{
    return YES; 
}


#pragma mark - View lifecycle

- (void)loadView
{
//    CGRect frame = [[UIScreen mainScreen] bounds]; 
    //add the scroller 
    infiniteScroller = [[InfinitePagedScrollView alloc] init]; 
    infiniteScroller.infiniteScrollDelegate = self; 
    self.view = infiniteScroller;  
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [infiniteScroller release]; 
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//this is an abstract class 
-(InfiniteScrollViewContent*) getContentAtPage:(int)page forScrollView:(InfinitePagedScrollView *)scrollView
{
    return nil; 
}


@end
