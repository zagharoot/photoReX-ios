//
//  DriverUIViewController.m
//  photoReX
//
//  Created by Ali Nouri on 3/9/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "DriverUIViewController.h"
#import "GraphWalkUIViewController.h"

@interface DriverUIViewController ()

@end

@implementation DriverUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openPressed:(id)sender {
    
    PictureInfo* picInfo = [[PictureInfo alloc] init];
    picInfo.info = [[FiveHundredPXPictureInfo alloc] initWithID:@"Test" andBaseURL:@"http://test" andHash:@"hashtest"];
    
    GraphNode* node = [[GraphNode alloc] initWithPictureInfo:picInfo andParent:nil];
    GraphWalkUIViewController* uc = [[GraphWalkUIViewController alloc] initWithRoot:node andFrame:self.view.bounds];
    
    [self presentModalViewController:uc animated:YES];
    
    
    
}
@end
