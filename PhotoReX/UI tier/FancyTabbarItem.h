//
//  FancyTabbarItem.h
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FancyTabbarItem : UIButton
{
    BOOL _selected; 
    
    UILabel* _textLabel; 
}

+(FancyTabbarItem*) buttonWithName:(NSString*) name andImageName:(NSString*) img;  
+(CGFloat) buttonHeight; 


@property (nonatomic) BOOL selected; 
@property (nonatomic, retain) UILabel* textLabel; 

@end
