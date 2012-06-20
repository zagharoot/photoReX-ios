//
//  ErrorViewController.m
//  photoReX
//
//  Created by Ali Nouri on 6/18/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "ErrorViewController.h"

@interface ErrorViewController ()

@end

@implementation ErrorViewController
@synthesize errorMessageTextBox;
@synthesize error; 
@synthesize domainLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithErrorMessage:(NSError *)err
{
    self = [super initWithNibName:@"ErrorViewController" bundle:[NSBundle mainBundle]]; 
    if (self)
    {
        self.error  = err; 
    }
    
    return self; 
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (! self.error)
        return; 
    
    self.domainLabel.text = self.error.domain; 
    
    if ([self.error.userInfo objectForKey:@"message"])
        self.errorMessageTextBox.text = [self.error.userInfo objectForKey:@"message"];
    else
        self.errorMessageTextBox.text = self.error.userInfo.description; 
    
}

- (void)viewDidUnload
{
    [self setErrorMessageTextBox:nil];
    [self setDomainLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissBtnClicked 
{
    [self.view removeFromSuperview]; 
    [self removeFromParentViewController]; 
    
}


- (void)dealloc {
    [errorMessageTextBox release];
    [domainLabel release];
    [super dealloc];
}
@end
