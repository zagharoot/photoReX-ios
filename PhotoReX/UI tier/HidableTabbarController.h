//
//  HidableTabbarController.h
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>


//This class is my take on tabbar controller. It allows the tabbar to hide by swipe motion and also draws the tabbar in a unique way. 

@protocol HidableTabbarDelegate <NSObject>
@optional
-(BOOL) needsEntirePage;        //if returns yes, the tabbar will hide itself as the page selected 
@end


@interface HidableTabbarController : UITabBarController <UITabBarControllerDelegate>
{
    CGFloat tabbarHeight;   
    
}


-(void) setup; 


-(void) hideOriginalTabbar; 

-(void) showBarWithAnimation:(BOOL) animation; 
-(void) hideBarWithAnimation:(BOOL) animation; 
-(void) changeTabbarAppearanceWithAnimation:(BOOL)animation toShow:(BOOL)show;      //this is auxiliary method

-(void) handleTabbarGesture:(UISwipeGestureRecognizer *)gestureRecognizer; 


+(HidableTabbarController*) getInstance;        //the singleton pattern (we never have two tabbars, right?) 


@end

