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



@interface FlickrAccountUIViewController : UIViewController <UIWebViewDelegate>
{    
    UIWebView *m_webView;
    FlickrAccount* _theAccount; 
    id<AccountActiveStatusDelegate> delegate; 
}



@property (nonatomic, retain) IBOutlet UIWebView *m_webView;
@property (nonatomic, retain) FlickrAccount* theAccount; 
@property (nonatomic, assign) id<AccountActiveStatusDelegate> delegate; 
@end
