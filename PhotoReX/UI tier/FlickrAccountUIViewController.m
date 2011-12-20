//
//  FlickrAccountUIViewController.m
//  rlimage
//
//  Created by Ali Nouri on 6/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "FlickrAccountUIViewController.h"


@implementation FlickrAccountUIViewController
@synthesize m_webView;
@synthesize theAccount=_theAccount; 
@synthesize notificationView=_notificationView; 

@synthesize apiRequest=_apiRequest; 

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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
        
    
    self.apiRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.theAccount.apiContext];
    self.apiRequest.delegate = self;
    self.apiRequest.requestTimeoutInterval = 60.0;
    
    [self.apiRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:@"www.rlimage.com"]];
    
    
    m_webView.delegate = self; 
    
    self.navigationController.title = @"Link to Flickr"; 
    
    self.notificationView.textLabel = @"Authorizing..."; 
    [self.notificationView setShowActivity:YES animated:YES]; 
    [self.notificationView show:YES]; 
}

-(void) closePage
{
    //return to account page 
    [self.navigationController popViewControllerAnimated:YES]; 
}

-(void) flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"flickr api error: %@\n", inError.description); 
    
    
    self.notificationView.textLabel = @"An error occurred. Please try again later!"; 
    self.notificationView.showActivity = NO; 
    
    [self performSelector:@selector(closePage) withObject:self afterDelay:2000]; 
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    self.theAccount.apiContext.OAuthToken = inRequestToken;
    self.theAccount.apiContext.OAuthTokenSecret = inSecret;
    self.theAccount.requestToken = inRequestToken; 
    
    NSURL *authURL = [self.theAccount.apiContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];


    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:authURL]; 
    m_webView.delegate = self; 
    [self.m_webView loadRequest:urlRequest]; 

}


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID
{
    //update the flickr account 
    self.theAccount.accessToken = inAccessToken; 
    self.theAccount.accessSecret = inSecret; 
    self.theAccount.username = inUserName;     
    [self.theAccount saveSettings]; 
    
    [self closePage]; 
}



-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = [request.URL absoluteString];  
    
    NSRange range = [url rangeOfString:@"www.rlimage.com"]; 
    if (range.location != NSNotFound) 
    {
        NSString *token = nil;
        NSString *verifier = nil;
        BOOL result = OFExtractOAuthCallback(request.URL, [NSURL URLWithString:@"http://m.flickr.com/www.rlimage.com"], &token, &verifier);
        
        if (!result) {
            NSLog(@"Cannot obtain token/secret from URL: %@", url);
            return YES;
        }
        
        [self.apiRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];
        self.notificationView.textLabel = @"Almost done!"; 
        
        return NO;
    }
    else
        return YES; 
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    self.theAccount = nil; 
    [m_webView release];
    [super dealloc];
}
@end
