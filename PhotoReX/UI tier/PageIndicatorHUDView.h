//
//  PageIndicatorHUDView.h
//  rlimage
//
//  Created by Ali Nouri on 10/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>


//  This class is used to show page information as a HUD

@interface PageIndicatorHUDView : UIView
{
    int _currentPage; 
    int _totalPage;
    UILabel* _textLabel; 
    UIColor* fillColor; 
    
    NSTimer* autohideTimer; 
}

-(void) showWithAnimation:(BOOL) animated andAutoHide:(BOOL) autoHide;               //shows the HUD view
-(void) hideWithAnimation:(BOOL) animated;               //hides the HUD view 
-(void) reloadTextLabel; 

-(void) invalidateAutohideTimer; 
-(void) resetAutohideTimer; 

@property (nonatomic) int currentPage; 
@property (nonatomic) int totalPage; 
@property (nonatomic, retain) UILabel* textLabel; 
@end
