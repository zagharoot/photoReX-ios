//
//  PageIndicatorHUDView.m
//  rlimage
//
//  Created by Ali Nouri on 10/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "PageIndicatorHUDView.h"

@implementation PageIndicatorHUDView

@synthesize currentPage=_currentPage; 
@synthesize totalPage=_totalPage; 
@synthesize textLabel=_textLabel; 


-(void) setCurrentPage:(int)currentPage
{
    _currentPage = currentPage; 
    [self reloadTextLabel]; 
}


-(void) setTotalPage:(int)totalPage
{
    _totalPage = totalPage; 
    [self reloadTextLabel]; 
    
}


-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame]; 
    if (self) 
    {
        self.backgroundColor = [UIColor clearColor]; 
        self.opaque = NO; 
        
        fillColor = [[UIColor colorWithHue:0.0 saturation:0.0 brightness:0 alpha:0.65] retain];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, frame.size.width - 8, 20)];
        _textLabel.font = [UIFont boldSystemFontOfSize:24];
        _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.minimumFontSize = 9; 
        [self addSubview:self.textLabel];
        
        
        autohideTimer = nil; 
    }
    
    
    return self; 
}


-(void) reloadTextLabel
{
    self.textLabel.text = [NSString stringWithFormat:@"%d / %d", self.currentPage, self.totalPage]; 
    [self setNeedsDisplay]; 
}


-(void) dealloc
{
    [_textLabel release]; 
    [fillColor release]; 
    [super dealloc]; 
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(2, self.frame.size.height / 2 - 15, self.frame.size.width-4, 20);
    
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = 0.5f;
//    self.layer.shadowOffset = CGSizeMake(.0f, .0f);
//    self.layer.shadowRadius = 2.0f;
//    self.layer.masksToBounds = NO;
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
//    self.layer.shadowPath = path.CGPath;
}


-(void) drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = 30; 
        
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

}


-(void) showWithAnimation:(BOOL)animated andAutoHide:(BOOL)autoHide
{
    [self invalidateAutohideTimer]; 
    if (!animated)
    {
        [self setHidden:NO]; 
        self.alpha = 1.0; 
    }else if (self.hidden)
    {
        //do the animation only if the view is hidden now
        
        self.alpha = 0; 
        [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationCurveLinear 
                         animations:^{self.alpha = 1; } 
                         completion:^(BOOL fin) { [self setHidden:NO];  } ]; 
    }
    
    if (autoHide)
    {
        [self resetAutohideTimer]; 
    }
    
    
}


-(void) hideWithAnimation:(BOOL)animated
{
    if (!animated)
        [self setHidden:YES]; 
    else if (!self.hidden)
    {
        self.alpha = 1.0; 
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationCurveEaseOut 
                         animations:^{self.alpha = 0; } 
                         completion:^(BOOL fin) { [self setHidden:YES];  } ]; 
    }
}



-(void) invalidateAutohideTimer
{
    [autohideTimer invalidate]; // if there was an active timer counting down, this stops it. if there was no instance, you can send any nil a message and the app doesn't crash.
    [autohideTimer release];
    autohideTimer = nil;
}


-(void) resetAutohideTimer{ // this method sets a timer and will call the hideUI method when the timer expires.
    
    if (autohideTimer) {
        [self invalidateAutohideTimer];
    }
    autohideTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(hideUI)
                                                    userInfo:nil
                                                     repeats:NO] retain];
    
    // now the timer has been set and has started counting down.
}

-(void) hideUI
{
    [self hideWithAnimation:YES]; 
}

@end
