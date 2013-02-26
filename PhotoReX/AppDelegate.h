//
//  AppDelegate.h
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

enum UserOrientation {
    UserOrientationUnknown = -1, 
    UserOrientationStanding = 1,
    UserOrientationLyingLeft = 2,
    UserOrientationLyingRight = 3
    };


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    enum UserOrientation _userOrientation;
    
    CGSize _windowSize;
    CGSize __isRetinaDisplay; 
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, nonatomic) enum UserOrientation userOrientation; 

//these  functions are used for showing splash screen 
+(void) setApplicationStartTime:(double) t; 
+(double) applicationStartTime; 
-(void) showSplashScreenOnView:(UIViewController*) v; 



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// conf values specific to each device (is computed automatically at launch time)
@property (readonly, nonatomic) CGSize windowSize;
@property (readonly, nonatomic) BOOL isRetinaDisplay;
-(NSString*) getImageName:(NSString*) name isResolutionSensitive:(BOOL) isResolutionSensitive;


@end
