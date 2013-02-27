//
//  AppDelegate.m
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "AppDelegate.h"
#import "PagedNavigatorController.h"
#import "ExploreImageProvider.h"
#import "ExploreNavigatorController.h"
#import "TestViewController.h"
#import "PagedNavigatorController.h"
#import "AccountsUIViewController.h"

#import "FancyTabbarController.h"

static double _applicationStartTime=0; 
#define SPLASH_SCREEN_DURATION 1           //number of seconds to show splash screen

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize userOrientation=_userOrientation; 
@synthesize isRetinaDisplay=_isRetinaDisplay;
@synthesize windowSize=_windowSize;

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
//    //The explore page
//    ExploreNavigatorController* exploreNavigator = [[ExploreNavigatorController alloc] init]; 
//
//    //The settings page:
//    AccountsUIViewController* accViewController =     [[AccountsUIViewController alloc] initWithNibName:@"AccountsUIViewController" bundle:[NSBundle mainBundle]];
//    UINavigationController* sunc = [[UINavigationController alloc] init]; 
//    [sunc pushViewController:accViewController animated:NO]; 
//    
//    
//    
//    exploreNavigator.tabBarItem.title = @"Explore"; 
//    sunc.tabBarItem.title = @"Settings"; 
//    
//        
//    //wrap the controllers into an array 
//    NSMutableArray* controllers = [NSMutableArray  arrayWithObjects:exploreNavigator, sunc, nil]; 
//    [exploreNavigator release]; 
//    [accViewController release]; 
//    [sunc release]; 
//    
//    //create the tabbar wrapper
//    HidableTabbarController* tabbarController = [HidableTabbarController getInstance];  
//    [tabbarController setViewControllers:controllers]; 
//    
//    
//    [self.window addSubview:tabbarController.view]; 
//    [self.window setRootViewController:tabbarController]; 
    
//    self.window.backgroundColor = [UIColor blackColor];
//    [self.window makeKeyAndVisible];
//    
//    if ( [[NSDate date] timeIntervalSince1970] - [AppDelegate applicationStartTime] < SPLASH_SCREEN_DURATION - 0.5)
//        [self showSplashScreenOnView:tabbarController ];

    FancyTabbarController* ftc = [FancyTabbarController getInstance]; 
    [self.window addSubview:ftc.view]; 
    [self.window setRootViewController:ftc]; 
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];

    _windowSize = [[UIScreen mainScreen] bounds].size;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        _isRetinaDisplay = YES;
    } else {
        // non-Retina display
        _isRetinaDisplay = NO;
    }
    
    CGRect rect = ftc.view.frame;
    CGRect nrect = CGRectMake(rect.size.width, rect.origin.y+20, rect.size.width, rect.size.height-20);
    ftc.view.frame  = nrect;
    if ( [[NSDate date] timeIntervalSince1970] - [AppDelegate applicationStartTime] < SPLASH_SCREEN_DURATION - 0.5)
        [self showSplashScreenOnView:ftc ];


    
    //initialize user orientation: 
    _userOrientation = UserOrientationUnknown; 
    switch ( [[UIApplication sharedApplication] statusBarOrientation])
    {
    case UIInterfaceOrientationPortrait: 
    case UIInterfaceOrientationPortraitUpsideDown: 
        _userOrientation = UserOrientationStanding; 
        break; 
        
    case UIInterfaceOrientationLandscapeLeft: 
        _userOrientation = UserOrientationLyingLeft; 
        break;
        
    case UIInterfaceOrientationLandscapeRight:
        _userOrientation = UserOrientationLyingRight; 
        break;
    }
    

//    UIDeviceOrientation o = [UIDevice currentDevice].orientation; 
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationLandscapeLeft:
            _userOrientation = UserOrientationLyingLeft; 
            break;
            
        case UIDeviceOrientationLandscapeRight:
            _userOrientation = UserOrientationLyingRight; 
            break;
            
        default:
            _userOrientation = UserOrientationStanding; 
            break;
    }
    return YES;
}

-(NSString*) getImageName:(NSString*) name isResolutionSensitive:(BOOL) isResolutionSensitive
{
    NSString* retStr = @"";
    if (self.isRetinaDisplay)
        retStr = @"@2x";
    
    NSString* resStr = @"";
    if (isResolutionSensitive)
        resStr = [NSString stringWithFormat:@"%dx%d", (int)self.windowSize.height, (int)self.windowSize.width];
    
    return [NSString stringWithFormat:@"%@%@%@.png",name,  resStr, retStr];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    //save web service settings 
    [[RLWebserviceClient standardClient] saveSettings]; 
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
    
    
    
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"photoReX" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"photoReX.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - Splash screen methods 
+(void) setApplicationStartTime:(double)t
{
    _applicationStartTime = t; 
}

+(double) applicationStartTime
{
    return _applicationStartTime; 
}

-(void) showSplashScreenOnView:(UIViewController *)v
{
    double duration = SPLASH_SCREEN_DURATION - ( [[NSDate date] timeIntervalSince1970] - [AppDelegate applicationStartTime]) ; 
    
    if (duration < 0.5) 
        return; 
    
    UIViewController* splash = [[[UIViewController alloc] init ] autorelease]; 
    UIImage* img;
    img = [UIImage imageNamed:[self getImageName:@"splash-02-" isResolutionSensitive:YES]];

    
    UIImageView* imgv = [[UIImageView alloc] initWithImage:img];
    imgv.frame = CGRectMake(0, 0, self.windowSize.width, self.windowSize.height);
    splash.view = imgv;
    [imgv release];
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    
    // main content is pulled from right to center. splash is moved out of screen to the left. then removed from superview
    CGRect rect = v.view.frame;
    CGRect srect = splash.view.frame; 
    CGRect nrect = CGRectMake(0, rect.origin.y, rect.size.width, rect.size.height);
    CGRect snrect = CGRectMake(-rect.origin.x, srect.origin.y, srect.size.width, srect.size.height);

    [self.window addSubview:splash.view];
//    [v presentViewController:splash animated:NO completion:^{}];
    
    [UIView animateWithDuration:0.8 delay:duration options:UIViewAnimationCurveEaseIn animations:^{
        v.view.frame = nrect;
        splash.view.frame = snrect;
    } completion:^(BOOL fin)
    {
        [splash.view removeFromSuperview];
//        [splash dismissViewControllerAnimated:NO completion:^{}];
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
    
}




@end
