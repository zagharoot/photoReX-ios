//
//  FancyTabbar.m
//  photoReX
//
//  Created by Ali Nouri on 12/21/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "FancyTabbar.h"
#import "FancyTabbarController.h"


@implementation FancyTabbar
@synthesize items=_items; 
@synthesize selectedIndex=_selectedIndex; 
@synthesize parent=_parent; 

#define BAR_TOP_MARGIN      5
#define BAR_BOTTOM_MARGIN   3
#define BAR_EDGE_INSET      20
#define BAR_HANDLE_HEIGHT   6 


-(void) setSelectedIndex:(int)selectedIndex
{
    if (selectedIndex <0 || selectedIndex >= self.items.count)
        return; 
    
    
    //unselect the old button
    if (_selectedIndex >=0)
       ( (FancyTabbarItem*) [self.items objectAtIndex:_selectedIndex]).selected = NO; 
    
    _selectedIndex = selectedIndex;
    ((FancyTabbarItem*) [self.items objectAtIndex:_selectedIndex]).selected = YES; 

    //inform delegate 
    [self.parent selectedItemDidChange:_selectedIndex]; 
    
    [self setNeedsDisplay]; 
}


-(id) init
{
    self = [super init]; 
    if (self) 
    {
        _items = [[NSMutableArray alloc] initWithCapacity:4]; 
        _selectedIndex = -1; 
        
        fillColor = [[UIColor colorWithHue:0.0 saturation:0.0 brightness:0 alpha:0.8] retain];
        strokeColor = [[UIColor colorWithHue:0 saturation:0 brightness:1 alpha:0.6] retain]; 
        self.backgroundColor = [UIColor clearColor]; 
        self.clipsToBounds = NO; 

/*        
        UIPanGestureRecognizer* flickDown = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFlickDownGesture:)]; 
        
        flickDown.delaysTouchesBegan = YES; 
        flickDown.delaysTouchesEnded = YES; 
        flickDown.maximumNumberOfTouches = 1; 
        [self addGestureRecognizer:flickDown]; 
        [flickDown release]; 
        
        
        
        //set up gesture recognizers for showing and hiding the tabbar 
        UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabbarGesture:)];
        
        swipe.direction = UISwipeGestureRecognizerDirectionDown; 
        swipe.delaysTouchesBegan = YES; 
        swipe.delaysTouchesEnded = YES; 
        [self addGestureRecognizer:swipe]; 
        [swipe release]; 
*/
        
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]; 
        
        tap.numberOfTapsRequired=1; 
        tap.numberOfTouchesRequired = 1; 
        
        [self addGestureRecognizer:tap]; 
        [tap release]; 
        
        
        isHandlingFlickDown = NO; 
        
    }
    
    return self; 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) addItemWithName:(NSString *)name andImageName:(NSString *)img
{
    FancyTabbarItem* item = [FancyTabbarItem buttonWithName:name andImageName:img]; 
    item.parentIndex = self.items.count; 
    
    [self.items addObject:item]; 
    [self addSubview:item]; 
    [item addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside]; 
}


-(void) buttonPushed:(id)sender
{
    FancyTabbarItem* item = (FancyTabbarItem*) sender; 

    self.selectedIndex = item.parentIndex; 
}



- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetFillColorWithColor(context,fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = 10; 
    
    CGFloat minx = CGRectGetMinX(rrect)+1;
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect)-1;
    CGFloat miny = CGRectGetMinY(rrect)+ BAR_HANDLE_HEIGHT+1; 
    CGFloat maxy = CGRectGetMaxY(rrect);
    
    CGFloat hw = 20;        //half the width of the handle 
    CGFloat hh = BAR_HANDLE_HEIGHT;         //height of the handle 

//    CGContextMoveToPoint(context, minx, maxy);
//    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
//    CGContextAddLineToPoint(context, maxx, maxy);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextMoveToPoint(context, minx, maxy);
    CGContextAddArcToPoint(context, minx, miny, midx-hw-5, miny, radius);   //5 is a small number 

    CGContextAddArcToPoint(context, midx-hw, miny, midx-hw+hh/2, miny-hh/2,3);
    CGContextAddArcToPoint(context, midx-hw+6, miny-hh, midx, miny-hh,3);
    CGContextAddArcToPoint(context, midx+hw-6, miny-hh, midx+hw-hh/2, miny-hh/2,3);
    CGContextAddArcToPoint(context, midx+hw, miny, midx+hw+5, miny,3);

    
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
    CGContextAddLineToPoint(context, maxx, maxy);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

}


-(void) layoutSubviews
{
    if (self.items.count==0)
        return; 
    
    //put the item in the middle 
    if (self.items.count==1)
    {
        return; 
    }
    
    CGFloat ITEM_WIDTH = 65; 
    
    CGRect f = self.bounds; 
    CGSize size = self.frame.size; 
    CGFloat w = size.width; 
    
    CGFloat curX = f.origin.x +  BAR_EDGE_INSET; 
    CGFloat padding = (w-2*BAR_EDGE_INSET - self.items.count*ITEM_WIDTH)/(self.items.count-1);
    for (FancyTabbarItem* item in self.items)
    {
        CGRect bf = CGRectMake(curX, f.origin.y+BAR_TOP_MARGIN + BAR_HANDLE_HEIGHT, ITEM_WIDTH, size.height- BAR_TOP_MARGIN - BAR_BOTTOM_MARGIN); 
        item.frame = bf; 
        curX += ITEM_WIDTH + padding; 
    }

}

-(void) dealloc
{
    [fillColor release]; 
    [strokeColor release]; 
    self.items = nil; 
    [super dealloc]; 
}


+(CGFloat) barHeight
{
    return [FancyTabbarItem buttonHeight] + BAR_TOP_MARGIN + BAR_BOTTOM_MARGIN + BAR_HANDLE_HEIGHT; 
}


#pragma mark- handling show/hide methods 

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //we allow the user to tap just a little above us if we're hidden (so we can show ourself by a tap) 
    if (!self.parent.isShowing)
        if (point.y>-9.5)
            return self; 
        else
            return nil; 
    
    if ( [self pointInside:point withEvent:event])
        return self; 
    else
        return nil; 
}

-(void) handleTapGesture:(UITapGestureRecognizer *)gesture
{
    if (! isHandlingFlickDown)
    {

        if (!self.parent.isShowing)                     //if hidden, we show by just a tap 
            [self.parent showBarWithAnimation:YES]; 
        

        //fire the corresponding button 
        for (FancyTabbarItem* btn in self.items) 
        {
            CGPoint p = [gesture locationInView:btn]; 
            if ( [btn pointInside:p withEvent:nil])
                [self buttonPushed:btn]; 
        }
    }
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 1) 
        return; 
    
    UITouch* touch = [touches anyObject]; 
    
    if (touch.tapCount>1)
        return; 
    
    startTouchLoc = [touch locationInView:self]; 
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    isHandlingFlickDown = YES; 
    CGPoint newPoint = [[touches anyObject] locationInView:self]; 
 
    if (newPoint.y > startTouchLoc.y+15 && fabs(newPoint.x - startTouchLoc.x) < 10)
        [self.parent hideBarWithAnimation:YES]; 
}


-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    isHandlingFlickDown = NO; 
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isHandlingFlickDown = NO; 
}


@end
