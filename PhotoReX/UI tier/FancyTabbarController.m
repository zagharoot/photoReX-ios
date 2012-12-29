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

//#define BAR_EDGE_INSET  6

FancyTabbarController* theInstance = nil; 

@implementation FancyTabbarController
@synthesize isShowing=_isShowing; 

+(FancyTabbarController*) getInstance
{
    if (! theInstance)
        theInstance = [[FancyTabbarController alloc] init]; 
    
    return theInstance; 
}


-(UIViewController*) selectedViewController
{
    if (selectedIndex<0)
        return nil; 
    
    if (selectedIndex >= viewControllers.count)
        return nil; 
    
    return [viewControllers objectAtIndex:selectedIndex]; 
}

-(void) setupGestures
{
    //set up gesture recognizers for showing and hiding the tabbar 
    UISwipeGestureRecognizer* flickUP = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabbarGesture:)];
    
    UISwipeGestureRecognizer* flickDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabbarGesture:)]; 
    
    flickUP.direction = UISwipeGestureRecognizerDirectionUp; 
    flickDown.direction = UISwipeGestureRecognizerDirectionDown; 
    flickDown.delaysTouchesBegan = YES; 
    
    [self.view addGestureRecognizer:flickUP]; 
    [self.view addGestureRecognizer:flickDown]; 
    
    [flickDown release]; 
    [flickUP release];     
}

-(void) setupViewControllers
{
    //CUSTOMIZE: create view controllers we need for this app. if we want to use this component in another place, we should rewrite this! sorry for not taking a general approach design 
        
    viewControllers = [[NSMutableArray alloc] initWithCapacity:3]; 
    autoHideArray   = [[NSMutableArray alloc] initWithCapacity:3]; 
    tabbar = [[FancyTabbar alloc] init]; 
    tabbar.parent = self; 
    
    //The explore page
    ExploreNavigatorController* exploreNavigator = [[ExploreNavigatorController alloc] init]; 
    [viewControllers addObject:exploreNavigator]; 
    [tabbar addItemWithName:@"Explore" andImageName:@"settingsIcon.png"]; 
    [exploreNavigator release]; 
    [autoHideArray addObject:[NSNumber numberWithBool:YES]]; 

    
    //The settings page:
    AccountsUIViewController* accViewController =     [[AccountsUIViewController alloc] initWithNibName:@"AccountsUIViewController" bundle:[NSBundle mainBundle]];
    accViewController.fancyTabbarController = self; 
    UINavigationController* sunc = [[UINavigationController alloc] init]; 
    [sunc pushViewController:accViewController animated:NO]; 
    [viewControllers addObject:sunc]; 
    [tabbar addItemWithName:@"Settings" andImageName:@"settingsIcon.png"]; 
    [sunc release]; 
    [accViewController release]; 
    [autoHideArray addObject:[NSNumber numberWithBool:NO]]; 
    
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
    selectedIndex = -1; 
    previousSelectedIndex = -1; 
    
    [self setupViewControllers]; 

    //link the tabbar 
    [self.view addSubview:tabbar]; 
    [self.view bringSubviewToFront:tabbar]; 
    
    [self setupGestures]; 
    
    _isShowing = YES; 
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.wantsFullScreenLayout = YES;
//    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    tabbar.selectedIndex = 0; 

    CGSize s = [[UIScreen mainScreen] applicationFrame].size; 
    
    CGRect barFrame = CGRectMake(BAR_EDGE_INSET, s.height-[FancyTabbar barHeight], s.width-BAR_EDGE_INSET*2, [FancyTabbar barHeight]+5); 
    tabbar.frame = barFrame; 
    
}



-(void) viewWillAppear:(BOOL)animated
{
    self.selectedViewController.view.frame = self.view.bounds; 
    [super viewWillAppear:animated]; 
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated]; 
    
    if ([autoHideArray objectAtIndex:tabbar.selectedIndex])
        [self performSelector:@selector(hideBarWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
 
    self.view = nil; 
    [viewControllers release]; 
    [tabbar release]; 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
     
     
-(void) selectedItemDidChange:(int)newIndex
{
    if (newIndex <0 || newIndex >= viewControllers.count)
        return; 
    
    
    //remove the old selectedView if present 
    if (self.selectedViewController)
    {
        [self.selectedViewController.view removeFromSuperview]; 

        // if selectedViewController is nil, it means its the first time, so we can't actually do this 
        if ([[autoHideArray objectAtIndex:newIndex] boolValue])
            [self performSelector:@selector(hideBarWithAnimation:) withObject:[autoHideArray objectAtIndex:newIndex] afterDelay:0.8]; 
    }
    
    previousSelectedIndex = selectedIndex; 
    selectedIndex = newIndex; 
    self.selectedViewController.view.frame = self.view.bounds;            //fills the entire page 
    [self.view insertSubview:self.selectedViewController.view atIndex:0]; 
}

-(void) gotoPreviousPage
{
    if (previousSelectedIndex<0)
        return ; 
    
    
    tabbar.selectedIndex = previousSelectedIndex; 
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
        _isShowing = YES; 
        tabbarFrame = CGRectMake(BAR_EDGE_INSET, b.size.height-[FancyTabbar barHeight],b.size.width-BAR_EDGE_INSET*2, [FancyTabbar barHeight]+5); 
	}
	else {
        _isShowing = NO; 
        tabbarFrame = CGRectMake(BAR_EDGE_INSET, b.size.height-BAR_HANDLE_HEIGHT,b.size.width-BAR_EDGE_INSET*2, [FancyTabbar barHeight]);
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
