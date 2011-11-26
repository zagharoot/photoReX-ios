//
//  HidableTabbarController.m
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "HidableTabbarController.h"

HidableTabbarController* theInstance; 

@implementation HidableTabbarController


+(HidableTabbarController*) getInstance
{
    if (! theInstance)
        theInstance = [[HidableTabbarController alloc] init]; 
    
    return theInstance; 
}

-(void) viewDidLoad
{
    //do some initialization 
    [self setup]; 
    tabbarHeight = self.tabBar.bounds.size.height; 
    self.delegate = self; 
    
    [super viewDidLoad]; 
    
    
//    [self hideOriginalTabbar];                  //we want to add our own tabbar so hiding the original one
}


-(void) setup
{
    //set up gesture recognizers for showing and hiding the tabbar 
    UISwipeGestureRecognizer* flickUP = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabbarGesture:)];
    
    UISwipeGestureRecognizer* flickDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabbarGesture:)]; 
    
    flickUP.direction = UISwipeGestureRecognizerDirectionUp; 
    flickDown.direction = UISwipeGestureRecognizerDirectionDown; 
    
    [self.view addGestureRecognizer:flickUP]; 
    [self.view addGestureRecognizer:flickDown]; 
    
    [flickDown release]; 
    [flickUP release]; 
    
}


-(void) viewWillAppear:(BOOL)animated
{
    //two cases here: if the user has learned to work with the tabbar, hide it as default
    //if not, show the tabbar and hide it after a while (letting user know he can bring it back up). 
    [self hideBarWithAnimation:NO]; 
}

-(void) showBarWithAnimation:(BOOL)animation
{
    [self changeTabbarAppearanceWithAnimation:animation toShow:YES]; 
}


-(void) hideBarWithAnimation:(BOOL)animation
{
    [self changeTabbarAppearanceWithAnimation:animation toShow:NO]; 
}

-(void) changeTabbarAppearanceWithAnimation:(BOOL)animation toShow:(BOOL)show
{
    //this probably should not happen. means we don't have any content page? 
	if ( [self.view.subviews count] < 2 ) {
		return;
	}
    
    
	UIView *contentView;
    
    //figure out what is the content page view
	if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
		contentView = [self.view.subviews objectAtIndex:1];
	} else {
		contentView = [self.view.subviews objectAtIndex:0];
	}
    
    CGRect contentFrame ; 
    CGRect tabbarFrame ;  
    
    CGRect b = self.view.bounds; 
	if (show) {
        self.tabBar.hidden = NO; 
		contentFrame = CGRectMake(self.view.bounds.origin.x,
                                  self.view.bounds.origin.y,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - tabbarHeight);
                
        tabbarFrame = CGRectMake(b.origin.x, b.origin.y + b.size.height-tabbarHeight, b.size.width, tabbarHeight); 
	}
	else {
		contentFrame = CGRectMake(self.view.bounds.origin.x,
                                  self.view.bounds.origin.y,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - 0*tabbarHeight);
        
        
        //        contentFrame = self.view.bounds; 
        tabbarFrame = CGRectMake(b.origin.x, b.origin.y + b.size.height, b.size.width, tabbarHeight); 
	}
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveLinear 
                     animations:^{
                         contentView.frame = contentFrame; 
                         self.tabBar.frame = tabbarFrame; 
                         
                     } 
                     completion:^(BOOL fin) {
                         self.tabBar.hidden = !show; 
                         [contentView setNeedsDisplay]; 
                     } ]; 
    
}



-(void) handleTabbarGesture:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return; 
    
    CGPoint loc =  [gestureRecognizer locationInView:self.view]; 
    
    //go up only if we have a touch on the bottom of the screen 
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp && loc.y > (self.view.bounds.origin.y + self.view.bounds.size.height)-70)
        [self showBarWithAnimation:YES]; 
    
    //we don't require hide gestures to be at the bottom of the page
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown)
        [self hideBarWithAnimation:YES]; 
}


#pragma - Delegate methods 

//each time we select a page, the tabbar automatically hides itself 
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController respondsToSelector:@selector(needsEntirePage)])
    {
        if ([viewController performSelector:@selector(needsEntirePage)])
            [self hideBarWithAnimation:YES]; 
    }
}



- (void)hideOriginalTabbar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}


@end
