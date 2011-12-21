//
//  FancyTabbarController.h
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FancyTabbar.h"

@interface FancyTabbarController : UIViewController <FancyTabbarDelegate>
{
    NSMutableArray* viewControllers;    //array of UIViewController
    UIViewController* selectedViewController; 
    
    FancyTabbar* tabbar; 
}

-(void) setupGestures; 
-(void) setupViewControllers; 


-(void) showBarWithAnimation:(BOOL) animation; 
-(void) hideBarWithAnimation:(BOOL) animation; 
-(void) changeTabbarAppearanceWithAnimation:(BOOL)animation toShow:(BOOL)show;      //this is auxiliary method

-(void) handleTabbarGesture:(UISwipeGestureRecognizer *)gestureRecognizer; 


+(FancyTabbarController*) getInstance;        //the singleton pattern (we never have two tabbars, right?) 

@end