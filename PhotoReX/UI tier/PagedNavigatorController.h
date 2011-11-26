//
//  PagedNavigatorController.h
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfinitePagedScrollView.h"
#import "PagedContentProvider.h"
#import "HidableTabbarController.h"

//  This class provides an infinite scroll of pages [0,\infty) for showing some stuff 

@interface PagedNavigatorController : UIViewController <InfiniteScrollDelegate, HidableTabbarDelegate>
{
    InfinitePagedScrollView* infiniteScroller; 
    
    id<PagedContentProvider> _contentProvider; 
}


-(id) initWithContentProvider:(id<PagedContentProvider>) provider; 


@property (nonatomic, retain) id<PagedContentProvider> contentProvider; 
@end
