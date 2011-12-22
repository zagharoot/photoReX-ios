//
//  FancyTabbarController.h
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FancyTabbar.h"


@interface FancyTabbarController : UIViewController
{
    NSMutableArray* viewControllers;    //array of UIViewController
    NSMutableArray* autoHideArray;      //array of BOOL (does each page need the tabbar to autohide when selected) 
    UIViewController* selectedViewController; 
    
    BOOL _isShowing;                 //are we showing the tabbar 
    FancyTabbar* tabbar; 
}

-(void) setupGestures; 
-(void) setupViewControllers; 
-(void) selectedItemDidChange:(int) selectedIndex; 


-(void) showBarWithAnimation:(BOOL) animation; 
-(void) hideBarWithAnimation:(BOOL) animation; 
-(void) changeTabbarAppearanceWithAnimation:(BOOL)animation toShow:(BOOL)show;      //this is auxiliary method

-(void) handleTabbarGesture:(UISwipeGestureRecognizer *)gestureRecognizer; 

@property (readonly) BOOL isShowing; 

+(FancyTabbarController*) getInstance;        //the singleton pattern (we never have two tabbars, right?) 

@end
