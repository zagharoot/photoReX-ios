//
//  FancyTabbarController.m
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "FancyTabbarController.h"

//CUSTOMIZE: 
#import "ExploreNavigatorController.h"
#import "AccountsUIViewController.h"

#define BAR_EDGE_INSET  8

FancyTabbarController* theInstance = nil; 

@implementation FancyTabbarController


+(FancyTabbarController*) getInstance
{
    if (! theInstance)
        theInstance = [[FancyTabbarController alloc] init]; 
    
    return theInstance; 
}

-(void) setupGestures
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

-(void) setupViewControllers
{
    //CUSTOMIZE: create view controllers we need for this app. if we want to use this component in another place, we should rewrite this! sorry for not taking a general approach design 
        
    viewControllers = [[NSMutableArray alloc] initWithCapacity:3]; 
    tabbar = [[FancyTabbar alloc] init]; 
    tabbar.deleage = self; 
    
    //The explore page
    ExploreNavigatorController* exploreNavigator = [[ExploreNavigatorController alloc] init]; 
    [viewControllers addObject:exploreNavigator]; 
    [tabbar addItemWithName:@"Explore" andImageName:@"exploreIcon"]; 
    [exploreNavigator release]; 

    
    //The settings page:
    AccountsUIViewController* accViewController =     [[AccountsUIViewController alloc] initWithNibName:@"AccountsUIViewController" bundle:[NSBundle mainBundle]];
    UINavigationController* sunc = [[UINavigationController alloc] init]; 
    [sunc pushViewController:accViewController animated:NO]; 
    [viewControllers addObject:sunc]; 
    [tabbar addItemWithName:@"Settings" andImageName:@"settingsButton.png"]; 
    [sunc release]; 
    [accViewController release]; 
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{    
    self.view = [[UIView alloc] init]; 
    selectedViewController = nil; 
    
    [self setupViewControllers]; 

    //link the tabbar 
    [self.view addSubview:tabbar]; 
    [self.view bringSubviewToFront:tabbar]; 
    
    tabbar.selectedIndex = 0; 
    [self setupGestures]; 
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    
    CGSize s = [[UIScreen mainScreen] applicationFrame].size; 
    self.view.frame = CGRectMake(0, 0, s.width, s.height); 
    
    selectedViewController.view.frame = self.view.frame; 
    
    CGRect barFrame = CGRectMake(BAR_EDGE_INSET, s.height-[FancyTabbar barHeight], s.width-BAR_EDGE_INSET*2, [FancyTabbar barHeight]+5); 
    tabbar.frame = barFrame; 
    
    [super viewWillAppear:animated]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [viewControllers release]; 
    [tabbar release]; 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
     
     
-(void) selectedItemDidChange:(int)selectedIndex
{
    if (selectedIndex <0 || selectedIndex >= viewControllers.count)
        return; 
    
    
    //remove the old selectedView if present 
    if (selectedViewController)
    {
        [selectedViewController.view removeFromSuperview]; 
    }
    
    
    selectedViewController = [viewControllers objectAtIndex:selectedIndex]; 
    selectedViewController.view.frame = self.view.frame;            //fills the entire page 
    [self.view insertSubview:selectedViewController.view atIndex:0]; 
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
   CGRect tabbarFrame ;  
        
    CGRect b = self.view.bounds; 
	if (show) {
        tabbarFrame = CGRectMake(BAR_EDGE_INSET, b.size.height-[FancyTabbar barHeight],b.size.width-BAR_EDGE_INSET*2, [FancyTabbar barHeight]+5); 
	}
	else {
        tabbarFrame = CGRectMake(BAR_EDGE_INSET, b.size.height-5,b.size.width-BAR_EDGE_INSET*2, [FancyTabbar barHeight]+5); 
	}
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveLinear 
                     animations:^{
                         tabbar.frame = tabbarFrame; 
                         
                     } 
                     completion:^(BOOL fin) {
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

@end
