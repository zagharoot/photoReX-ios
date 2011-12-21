//
//  FancyTabbar.h
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FancyTabbarItem.h"

@protocol FancyTabbarDelegate <NSObject>

-(void) selectedItemDidChange:(int) selectedIndex; 
@end


@interface FancyTabbar : UIView
{
    int _selectedIndex; 
    NSMutableArray* _items;  //array of fancytabbaritems 
    
    id<FancyTabbarDelegate> _delegate; 
    
    UIColor* fillColor; 
    UIColor* strokeColor; 
    
}

+(CGFloat) barHeight; 

-(void) addItemWithName:(NSString*) name andImageName:(NSString*) img; 

-(void) buttonPushed:(id) sender; 

@property (nonatomic, retain) NSMutableArray* items; 
@property (nonatomic) int selectedIndex; 
@property (nonatomic, assign) id<FancyTabbarDelegate> deleage; 


@end
