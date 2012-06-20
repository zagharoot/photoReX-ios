//
//  ErrorViewController.h
//  photoReX
//
//  Created by Ali Nouri on 6/18/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 
 This is mainly a debugging tool, so it can be removed for production. It basically shows error message in a page. 
 
 */


@interface ErrorViewController : UIViewController
{
    NSError* error; 
}

@property (retain, nonatomic) IBOutlet UITextView *errorMessageTextBox;
@property (nonatomic, retain) NSError* error; 
@property (retain, nonatomic) IBOutlet UILabel *domainLabel;

- (IBAction)dismissBtnClicked;

-(id) initWithErrorMessage:(NSError*) err; 


@end
