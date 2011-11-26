//
//  ExploreNavigatorController.m
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "ExploreNavigatorController.h"
#import "ExploreImageProvider.h"
#import "ImageGridUIViewController.h"

@implementation ExploreNavigatorController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return nil; 
}

//this is the designated initializer 
-(id) init
{
    ExploreImageProvider* ex = [[ExploreImageProvider alloc] initWithUserid:@"ali"]; 
    self = [super initWithContentProvider:ex];     
    [ex release]; 
    
    return self; 
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor]; 
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Infinite ScrollView delegate methods 

-(InfiniteScrollViewContent*) getContentAtPage:(int)page forScrollView:(InfinitePagedScrollView *)scrollView
{
//    NSLog(@"retrieving page %d for scrollview\n", page);
    ImageGridUIViewController* content = (ImageGridUIViewController*)  [scrollView dequeuePageWithKey:@"ImageGridUIViewController"]; 
    
    if (content == nil) 
    {
        content = [[[ImageGridUIViewController alloc] initWithNibName:@"ImageGridUIViewController" bundle:[NSBundle mainBundle]] autorelease]; 
    }
    
    content.page = page; 
    
    content.imageSource = [self.contentProvider getContentAtPage:page];  
    
    return content;
}


@end









