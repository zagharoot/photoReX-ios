//
//  FlickrAccountUIViewController.h
//  rlimage
//
//  Created by Ali Nouri on 6/30/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrAccount.h"
#import "AccountTableViewCell.h"
#import "ObjectiveFlickr.h"
#import "GCDiscreetNotificationView.h"

@interface FlickrAccountUIViewController : UIViewController <UIWebViewDelegate, OFFlickrAPIRequestDelegate>
{    
    UIWebView *m_webView;
    FlickrAccount* _theAccount; 
    
    OFFlickrAPIRequest* _apiRequest; 
    GCDiscreetNotificationView* _notificationView; 
}

-(void) closePage; 

@property (nonatomic, retain) GCDiscreetNotificationView*  notificationView; 
@property (nonatomic, retain) IBOutlet UIWebView *m_webView;
@property (nonatomic, retain) FlickrAccount* theAccount; 

//objective flickr stuff 
@property (nonatomic, retain) OFFlickrAPIRequest* apiRequest; 




@end
