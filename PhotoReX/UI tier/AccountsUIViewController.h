//
//  AccountsUIViewController.h
//  photoReX
//
//  Created by Ali Nouri on 11/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FancyTabbarController; 

@interface AccountsUIViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary* accountCells; //this is a dictionary from indexPath to AccountTableViewCell necessary to compute the row height
    
    IBOutlet UITableView *tableView;
    
    UIBarButtonItem * _closeBtn; 
    FancyTabbarController* _fancyTabbarController; 
}

-(void) closePage:(id) sender; 
-(void) reevaluateHeights; 


@property (nonatomic, retain) UIBarButtonItem* closeBtn; 
@property (nonatomic, assign) FancyTabbarController* fancyTabbarController; 
@end
