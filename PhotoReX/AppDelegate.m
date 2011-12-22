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



@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

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
    if ( [[NSDate date] timeIntervalSince1970] - [AppDelegate applicationStartTime] < SPLASH_SCREEN_DURATION - 0.5)
    [self showSplashScreenOnView:ftc ];

        
    return YES;
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
    UIImage* img = [UIImage imageNamed:@"splash-02.png"];
    UIImageView* imgv = [[UIImageView alloc] initWithImage:img]; 
    splash.view = imgv; 
    [imgv release]; 
    [v presentModalViewController:splash animated:NO]; 
    
    [splash performSelector:@selector(dismissModalViewControllerAnimated:) withObject:nil afterDelay:duration]; 
}




@end
