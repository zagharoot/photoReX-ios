//
//  InfinitePagedScrollView.h
//  rlimage
//
//  Created by Ali Nouri on 7/5/11.
//  Copyright 2011 Rutgers. All rights reserved.
//
//  This class provides a scrollview that can scroll contents in an infinite space horizontally. It starts at page 0 and 
//  can go to arbitrary large page numbers. It also implements a tiling mechanism that brings only the visible pages into 
//  memory and recycles the rest as they go outside of the bound. It page should be of type InfiniteScrollViewContent. 
//
//  The controller that uses this scroller needs to implement the InfiniteScrollDelegate protocol that provides a mechansim 
//  to initialize and set the content of the pages as they fall inside the visible bounds

#import <UIKit/UIKit.h>
#import "PageIndicatorHUDView.h"

//-----------------------------------------------------

@class InfinitePagedScrollView; 

//This is the abstract class for the content of the pages
@interface InfiniteScrollViewContent: UIViewController
{
    int _page;                          //what page am I in
}
@property (nonatomic) int page; 
@end

//----------------------


@protocol InfiniteScrollDelegate <NSObject>

-(InfiniteScrollViewContent*) getContentAtPage:(int) page forScrollView:(InfinitePagedScrollView*) scrollView; 
@end



//----------------------

@interface InfinitePagedScrollView : UIScrollView
{
    //difference between the current contentOffset and the real offset in our infinite space. 
    int offsetDiff;        

    PageIndicatorHUDView* pageIndicator; 
    NSMutableDictionary*  reusablePages;       //(recycle for performance): dictionary of content sets
    NSMutableDictionary*  activePages;         //pages that are actively present as part of our subview (indexed by their page number)
    id<InfiniteScrollDelegate> _idelegate; 

    //stuff related to computing current page
    CGPoint lastContentOffset; 
    NSRange virtualPageRange;                   //range of visible pages in the views world (it's a finite world)
    NSRange infinitePageRange;                  //range of visible pages in the infinite world 
    int currentPageIndex;                       //a single number recognizing what the current page is 
    int maxPage;                                //how many pages do we have 
    BOOL showHUDForLastPage;                    //whether we should show the HUD for the last page (show only when the user has navigated back and is coming back)
}

@property (nonatomic, retain) id<InfiniteScrollDelegate> infiniteScrollDelegate; 
@property (nonatomic, readonly) NSMutableDictionary* activePages; 

-(void) updatePageLocationVariables;
-(int) pageCount;                           //returns how many pages have been seen so far 
-(void) recyclePagesNotInRange:(NSRange) theRange; 
-(int) originalToVirtualPage:(int) p; 
-(void) ensureViewExist:(NSRange) range;     //makes sure the specified pages are avaialbe in subview. If not, creates them
-(InfiniteScrollViewContent*) dequeuePageWithKey:(NSString*) key;   //creates a content page initialized with page or retrieves one from the queue
@end 






