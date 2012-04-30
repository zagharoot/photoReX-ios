//
//  fiveHundredPXAccountUIViewController.m
//  photoReX
//
//  Created by Ali Nouri on 4/29/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import "fiveHundredPXAccountUIViewController.h"

@interface fiveHundredPXAccountUIViewController ()

@end

@implementation fiveHundredPXAccountUIViewController
@synthesize m_webView;
@synthesize theAccount=_theAccount; 
@synthesize notificationView=_notificationView; 

-(GCDiscreetNotificationView*) notificationView
{
    if (!_notificationView)
        _notificationView = [[GCDiscreetNotificationView alloc] initWithText:@"" 
                                                                showActivity:YES
                                                          inPresentationMode:GCDiscreetNotificationViewPresentationModeTop 
                                                                      inView:self.view];
    
    return _notificationView; 
}



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
/*
    self.apiRequest = [[[OFFlickrAPIRequest alloc] initWithAPIContext:self.theAccount.apiContext] autorelease];
    self.apiRequest.delegate = self;
    self.apiRequest.requestTimeoutInterval = 60.0;
    
    [self.apiRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:@"www.rlimage.com"]];
*/    
    
    m_webView.delegate = self; 
    
    self.navigationController.title = @"Link to 500Px"; 
    
    self.notificationView.textLabel = @"Authorizing..."; 
    [self.notificationView setShowActivity:YES animated:YES]; 
    [self.notificationView show:YES]; 


}

-(void) closePage
{
    //return to account page 
    [self.navigationController popViewControllerAnimated:YES]; 
}


- (void)viewDidUnload
{
    [self setNotificationView:nil]; 
    [self setM_webView:nil];
    [super viewDidUnload];
    self.theAccount = nil; 
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    self.theAccount = nil; 
    [m_webView release];
    [super dealloc];
}



#pragma -mark web view delegates 
-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = [request.URL absoluteString];  
    
    NSRange range = [url rangeOfString:@"www.rlimage.com"]; 
    if (range.location != NSNotFound) 
    {
/*        NSString *token = nil;
        NSString *verifier = nil;
        BOOL result = OFExtractOAuthCallback(request.URL, [NSURL URLWithString:@"http://m.flickr.com/www.rlimage.com"], &token, &verifier);
        
        if (!result) {
            NSLog(@"Cannot obtain token/secret from URL: %@", url);
            return YES;
        }
        
        [self.apiRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];
        self.notificationView.textLabel = @"Almost done!"; 
        [self.notificationView showAnimated]; 
*/        
        return NO;
    }
    else
        return YES; 
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.notificationView hideAnimated]; 
}





@end
