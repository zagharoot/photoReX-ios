//
//  FancyTabbar.h
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FancyTabbarItem.h"

@class FancyTabbarController; 

@interface FancyTabbar : UIView
{
    int _selectedIndex; 
    NSMutableArray* _items;  //array of fancytabbaritems 
    
    FancyTabbarController* _parent; 
    
    UIColor* fillColor; 
    UIColor* strokeColor; 
    
    BOOL isHandlingFlickDown;           //this is a flag that tracks whether we are examining to hide or not
    CGPoint startTouchLoc;              //the place where the touch started (used for show/hide)
}

+(CGFloat) barHeight; 

-(void) addItemWithName:(NSString*) name andImageName:(NSString*) img; 

-(void) buttonPushed:(id) sender; 
-(void) handleTapGesture:(UITapGestureRecognizer*) gesture; 

@property (nonatomic, retain) NSMutableArray* items; 
@property (nonatomic) int selectedIndex; 
@property (nonatomic, assign) FancyTabbarController* parent; 


@end
