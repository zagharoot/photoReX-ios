//
//  InfinitePagedScrollView.m
//  rlimage
//
//  Created by Ali Nouri on 7/5/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "InfinitePagedScrollView.h"

@implementation InfinitePagedScrollView

@synthesize infiniteScrollDelegate=_idelegate; 
@synthesize activePages; 
/*
Since some computations are done in each page rendering frame, we precompute some values that don't change in the followings: 
*/


#define NUMBER_OF_PAGES 7       //number of pages that the scroll view assigns to its contentsize (shouldn't matter much)

static CGFloat PAGE_WIDTH; 
static CGFloat PAGE_HEIGHT; 
static CGFloat CENTER_POSITION; //the x position of the page in the middle (the position we periodically move pages to)

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame]; 
}


-(void) _didMoveFromWindow:(UIWindow*) w1 toWindow:(UIWindow*) w2
{
//    [super _didMoveFromWindow:w1 toWindow:w2]; 
}



-(void) setup 
{
    self.pagingEnabled = YES; 

    offsetDiff = 0;     //initially we are synced with the real coordinate
    lastContentOffset = CGPointMake(0, 0); 
    maxPage = 1; 
    currentPageIndex = 0; 
    showHUDForLastPage = NO; 
    
    //TODO: we need to use self.bounds to compute these, but we also want to cache the value for fast access. How to do it? 
    //TODO: we need to find the height of the status bar automatically
    CGFloat statusHeight = 20;
    PAGE_WIDTH =  [[UIScreen mainScreen] bounds].size.width;
    PAGE_HEIGHT =  [[UIScreen mainScreen] bounds].size.height - statusHeight ;
    CENTER_POSITION = ((int) (NUMBER_OF_PAGES / 2))*PAGE_WIDTH; 
    
    self.contentSize = CGSizeMake(PAGE_WIDTH*NUMBER_OF_PAGES, self.bounds.size.height);
    
    //create the sets and all...
    reusablePages = [[NSMutableDictionary alloc] initWithCapacity:5];       
    activePages = [[NSMutableDictionary alloc] initWithCapacity:3]; 
    
    
    //hide the scroll indicators
    self.showsHorizontalScrollIndicator = NO; 
    self.showsVerticalScrollIndicator = NO; 
    
    
    self.bounces = YES; 
    
    float hudwidth = 150; 
    float hudheight = 150; 
    CGRect frame = CGRectMake((PAGE_WIDTH-hudwidth)/2.0, (PAGE_HEIGHT-hudheight)/2.0, hudwidth, hudheight); 
    pageIndicator = [[PageIndicatorHUDView alloc] initWithFrame:frame]; 
    [self addSubview:pageIndicator]; 
    pageIndicator.hidden = YES; 
    
    
    //TODO: remove this 
    CGRect af = CGRectMake(-20-PAGE_HEIGHT/2, PAGE_HEIGHT/2 -10, PAGE_HEIGHT, 30); 
    UILabel* alaki = [[UILabel alloc] initWithFrame:af]; 
    alaki.backgroundColor = [UIColor clearColor]; 
    UIFont* font = [UIFont fontWithName:@"copperplate" size:30];
    alaki.font = font; 
    alaki.text = @"At the Beginning"; 
    alaki.textAlignment = UITextAlignmentCenter; 
    CGAffineTransform swingTransform = CGAffineTransformIdentity;
    swingTransform = CGAffineTransformRotate(swingTransform, -M_PI_2);
    alaki.transform = swingTransform;
    
    [self addSubview:alaki]; 
    
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self setup]; 
    }
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder]; 
    if (self)
    {
        [self setup]; 
    }
    
    return self; 
}


-(int) pageCount
{
    return maxPage; 
}


// This function looks at the contentOffset and if we are about to hit the end of our contentSize, moves everything back 
// to the middle. 
-(void) recenterIfNecessary:(NSRange) range
{
    
    CGFloat xoff = self.contentOffset.x; 
    
    
    //for bouncing: don't allow it to scroll way too much to the left of the first page(cosmetic code only) 
    if (xoff <-60)
    {
        CGPoint p = self.contentOffset; 
        p.x = -60 + (p.x+60)/3; 
        [self setContentOffset:p]; 
        return; 
    }
    
    
    
    if ( (xoff >= self.contentSize.width - 2*PAGE_WIDTH)                    //if we reach the page before last one
        || (xoff <= PAGE_WIDTH && offsetDiff>0)  )                          //if we reach the second page and we can scroll back
    {   
        CGFloat xdiff = ( xoff - CENTER_POSITION) - ( (int)xoff % (int)PAGE_WIDTH); 
    
        if (offsetDiff + xdiff < 0 )            //the maximum to shift back is to go to the original setting not more. 
            xdiff = - offsetDiff;           
        
        
        self.contentOffset = CGPointMake(CENTER_POSITION, self.contentOffset.y); 
        
        offsetDiff += xdiff; //update the absolute diff 
    
        
        //also shift all the active contents
        NSEnumerator* enumerator = [activePages objectEnumerator]; 
        InfiniteScrollViewContent* content; 
        while ((content=[enumerator nextObject]))
        {
            CGRect frame = content.view.frame; 
            
            frame.origin.x -= xdiff; 
            [content.view setFrame:frame]; 
        }
    }
}



-(void) layoutSubviews
{
//    NSLog(@"infinite layout content (%f,%f) (%f,%f) \n", self.contentSize.width, self.contentSize.height, self.contentOffset.x, self.contentOffset.y); 
    
    
    [super layoutSubviews]; 
    
    [self updatePageLocationVariables]; 
    NSRange currentRangeOriginal = infinitePageRange;   
    
//    NSLog(@"pages from %d and length %d\n", currentRangeOriginal.location, currentRangeOriginal.length);

    //first, recycle pages that are not visible 
    [self recyclePagesNotInRange:currentRangeOriginal]; 
    
    //second, ensure we have the pages loaded for the current range
    NSRange visibleRange = currentRangeOriginal; 
    if (visibleRange.location>0) {visibleRange.location = visibleRange.location - 1; visibleRange.length +=1; }
    [self ensureViewExist:visibleRange]; 
    
    //and shift the contents if necessary
    [self recenterIfNecessary:currentRangeOriginal]; 
    

    
//    CGFloat startX = [self originalToVirtualPage:pageNumber.intValue]*PAGE_WIDTH; 
//    CGRect frame = CGRectMake(startX, 0, PAGE_WIDTH, PAGE_HEIGHT); 
  
    CGPoint s =  self.contentOffset; 
    CGFloat hudwidth = pageIndicator.frame.size.width; 
    CGFloat hudheight = pageIndicator.frame.size.height; 
    CGRect frame = CGRectMake(s.x+(PAGE_WIDTH-hudwidth)/2.0, s.y+(PAGE_HEIGHT-hudheight)/2.0 , hudwidth, hudheight); 
    [pageIndicator setFrame:frame]; 
    [self bringSubviewToFront: pageIndicator]; 
    
    pageIndicator.currentPage = currentPageIndex+1; 
    pageIndicator.totalPage = [self pageCount];  
    
    
//    NSLog(@"in layoutviews\n"); 
    
}





-(void) dealloc
{
    self.infiniteScrollDelegate = nil; 
    
    [reusablePages dealloc]; 
    [activePages dealloc]; 
    
    [super dealloc]; 
}


-(void) updatePageLocationVariables
{
    CGFloat xpos = self.contentOffset.x; 
    int pmin = MAX(0,floor(xpos/PAGE_WIDTH)); 
    int pmax = ceil(1+xpos/PAGE_WIDTH); 
    
    
    virtualPageRange = NSMakeRange(pmin, pmax-pmin); 
    infinitePageRange = NSMakeRange(virtualPageRange.location+ offsetDiff/PAGE_WIDTH, virtualPageRange.length); 
    
    //update page count
    if (infinitePageRange.location >= maxPage)
    {
        maxPage = infinitePageRange.location+1; 
        showHUDForLastPage = NO;                    //anytime the user swipes to the right side of the available pages, we remove the HUD or it'll be very annoying 
    }
    
    //compute current page index 
    int newPage = 0; 
    if (infinitePageRange.length==1)
        newPage = infinitePageRange.location; 
    else
    {
        CGFloat leftOffset = ( (int)xpos % (int)PAGE_WIDTH); 
        double percentage ; 
        //which direction are we panning? 
        if (xpos < lastContentOffset.x)      //going left 
        {
            percentage = 0.2; 
        }else   //going right 
        {
            percentage = 0.8; 
        }
        
       // NSLog(@"leftoffset %f, perc %f\n", leftOffset, percentage); 
        
        if (leftOffset > PAGE_WIDTH*percentage)
            newPage = infinitePageRange.location+1; 
        else
            newPage = infinitePageRange.location; 
        
        if (newPage > maxPage-1)
        {
            newPage = maxPage-1; 
        }
    }
    
    //if the user is going back in the history, turn on the HUD view 
    if (newPage < maxPage -1)
        showHUDForLastPage = YES; 
        
    
    if (newPage != currentPageIndex && showHUDForLastPage )
    {
        [pageIndicator showWithAnimation:NO andAutoHide:YES]; 
    }
    
    currentPageIndex = newPage; 
    lastContentOffset = self.contentOffset; 
}



// This function looks at all the pages that should be visible and makes sure we have the objects for them in activePages 
-(void) ensureViewExist:(NSRange)range
{
    for(int i=0; i< range.length; i++)      //for all the pages that need to be present
    {
        NSNumber* pageNumber =  [NSNumber numberWithInt:i + range.location] ; 
        
    
        InfiniteScrollViewContent* obj=  [activePages objectForKey:pageNumber]; 
        if (obj == nil) //if the object doesn't already exist
        {
            obj = [self.infiniteScrollDelegate getContentAtPage:pageNumber.intValue forScrollView:self]; 
            
            CGFloat startX = [self originalToVirtualPage:pageNumber.intValue]*PAGE_WIDTH; 
            CGRect frame = CGRectMake(startX, 0, PAGE_WIDTH, PAGE_HEIGHT); 
            
            
            [self addSubview:obj.view];
            [obj.view setFrame:frame];
            
            
            [activePages setObject:obj forKey:pageNumber]; 
            pageIndicator.totalPage = [activePages count];
            
            
        }
    }
}

// This function removes pages that are not visible in the bounds from their super view and puts them in a set for recycling
-(void) recyclePagesNotInRange:(NSRange)theRange
{
    
    int pmin = theRange.location; 
    int pmax = pmin+ theRange.length - 1; 
    
    
    NSMutableArray* keysToDelete = [NSMutableArray arrayWithCapacity:3];                    //this contains the stuff we want to remove from activePages
    
    NSEnumerator *enumerator = [activePages objectEnumerator];
    
    InfiniteScrollViewContent* content; 
    
    while ((content = [enumerator nextObject]))         //for all the active pages
    {
        if (content.page < (pmin-1) || content.page > (pmax+1)) //recycle the page if out of bound
        {
            NSString* key = [[content class] description]; 
            NSMutableSet* set = [reusablePages objectForKey:key]; 
            if (set == nil)                                 //first time adding a page, should create the set
            {
                set = [NSMutableSet setWithObject:content]; 
            }
            
            [set addObject:content] ;
            [content.view removeFromSuperview]; 
            NSNumber* theKey = [NSNumber numberWithInt:content.page]; 
            [keysToDelete addObject:theKey]; 
        }
    }
    
    
    [activePages removeObjectsForKeys:keysToDelete]; 
    
}


-(int) originalToVirtualPage:(int)p
{
    int result = p - (offsetDiff)/PAGE_WIDTH; 
    return result; 
}


// This function recycles a requested page from the queue
-(InfiniteScrollViewContent*) dequeuePageWithKey:(NSString *)key
{
    NSMutableSet* theSet = [reusablePages objectForKey:key]; 
    
    if (theSet == nil)
        return nil; 
    
    //any one of the available contents would do the job
    InfiniteScrollViewContent* result = [theSet anyObject]; 
    
    if (result) //remove it from the set 
    {
        [[result retain] autorelease]; 
        [theSet removeObject:result]; 
    }
    
    
    return result; 
}

-(CGSize) getPageSize
{
    return CGSizeMake(PAGE_WIDTH, PAGE_HEIGHT);
}

@end


//--------------------------------------------------

@implementation InfiniteScrollViewContent

@synthesize page=_page; 
@synthesize pageSize = _pageSize;



-(id) initForPageSize:(CGSize)ps
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.pageSize = ps;
    }
    
    return self;
}

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil            //we dont allow this 
{
    return nil;
}

@end

