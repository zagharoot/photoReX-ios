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
@synthesize delegate; 

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
    // Do any additional setup after loading the view from its nib.
    
    //NSString* sig = @"32c600fad81cf3e3api_keya73d15993130578b1489177a9912aeaapermsread"; 
    
    //This string is the MD5 encryption of the above string (do it using the command line md5)
    NSString* sig = @"f454cf953f00d0819ccf5064242f9e71"; 
    
    //customized url for the application
    NSString* url = @"http://flickr.com/services/auth/?api_key=a73d15993130578b1489177a9912aeaa&perms=read&api_sig="; 
    
    url = [url stringByAppendingString:sig]; 
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]]; 
    m_webView.delegate = self; 
    
    [self.m_webView loadRequest:request]; 
                             
}


-(NSString*) extractFrobFromURL:(NSURL*) url
{
    NSString* us = [url absoluteString]; 
    NSRange frobPos = [us rangeOfString:@"frob"]; 
    
    //doesn't have the frobkey
    if (frobPos.location == NSNotFound)
        return nil; 
    
    NSString* result = [us substringFromIndex:frobPos.location + 5]; 
    
    
    return result; 
}


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* url = request.URL; 
    
    if ([[url host] isEqualToString:@"www.rlimage.com"])    //successfully authorized the account: take note of the frobKey and exit
    {
        NSString* frob = [self extractFrobFromURL:url];  

        if (frob != nil)    //we've got a working frob: save it and take ourselves from nav stack. 
        {
            self.theAccount.frobKey = frob; 
            [self.theAccount saveSettings]; 
            
            [self.navigationController popViewControllerAnimated:YES]; 
            [self.delegate accountStatusDidChange]; 
        }
        
        return NO;
    }
    else
        return YES; 
}

- (void)viewDidUnload
{
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
