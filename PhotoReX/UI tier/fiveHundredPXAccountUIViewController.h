//
//  fiveHundredPXAccountUIViewController.h
//  photoReX
//
//  Created by Ali Nouri on 4/29/12.
//  Copyright (c) 2012 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiveHundredPXAccount.h" 
#import "AccountTableViewCell.h"
#import "GCDiscreetNotificationView.h"
#import "ObjectiveFlickr.h"

@interface fiveHundredPXAccountUIViewController : UIViewController <UIWebViewDelegate, OFFlickrAPIRequestDelegate>
{
    FiveHundredPXAccount* _theAccount; 
    GCDiscreetNotificationView* _notificationView; 
    OFFlickrAPIRequest* _apiRequest; 

}
@property (retain, nonatomic) IBOutlet UIWebView *m_webView;

@property (nonatomic, retain) GCDiscreetNotificationView*  notificationView; 
@property (nonatomic, retain) FiveHundredPXAccount* theAccount; 


//objective flickr stuff 
@property (nonatomic, retain) OFFlickrAPIRequest* apiRequest; 




-(void) closePage; 

@end
