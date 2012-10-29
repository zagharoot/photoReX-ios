//
//  ImageStatusOverlayLayer.m
//  photoRexplore
//
//  Created by Ali Nouri on 11/25/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "ImageStatusOverlayView.h"
#import "PictureInfo.h"

#define STATUS_ICON_WIDTH   15


@implementation ImageStatusOverlayView
@synthesize alwaysShow=_alwaysShow;

-(id) initWithPictureInfo:(PictureInfo *)p andParentFrame:(CGRect)f
{
    CGRect frame = CGRectMake(0, 0, f.size.width+2, 20); 
    self = [super initWithFrame:frame]; 
    if (self)
    {
        pictureInfo = p; 
        self.backgroundColor = [UIColor clearColor]; 
        self.opaque = NO;
        self.alwaysShow = NO;
        
    }
    
    return self; 
}


-(void) drawRect:(CGRect)rect
{
    if ( (! self.alwaysShow) && ( pictureInfo.userActivityStatus == ImageActivityStatusNotVisited ||
        pictureInfo.userActivityStatus == ImageActivityStatusUnknown))
        return; 
    
    //draw the band itself
    CGFloat curX = 5;
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context); 
    CGContextSetFillColorWithColor(context, [UIColor colorWithHue:0.0 saturation:0.0 brightness:0 alpha:0.65].CGColor);
    CGContextFillRect(context, self.frame); 
    
    UIGraphicsPopContext(); 

    //------------------------- draw icons on the band

    
    
    // if it has been viewed, draw it.
    if (pictureInfo.userActivityStatus == ImageActivityStatusViewed)
    {
        CGRect rect = CGRectMake(curX, 5, 13, 10); 
        curX += 23;
        UIImage* img = [UIImage imageNamed:@"viewed.png"];
        CGContextDrawImage(context, rect, img.CGImage); 
    }


    //draw the provider
    //website: 
    NSString* iconName = @"";
    switch (pictureInfo.info.website) {
        case FLICKR_INDEX:
            iconName = @"flickrIconInBand.png";
            break;
        case INSTAGRAM_INDEX:
            iconName = @"instagramIconInBand.png";
            break;
        case FIVEHUNDREDPX_INDEX:
            iconName = @"500pxIconInBand.png";
            break;
        default:
            break;
    }
    CGRect providerRect = CGRectMake(curX, 5, 13, 10);
    curX += 23;
    UIImage* img = [UIImage imageNamed:iconName] ;
    CGContextDrawImage(context, providerRect, img.CGImage);
    
    

}





@end
