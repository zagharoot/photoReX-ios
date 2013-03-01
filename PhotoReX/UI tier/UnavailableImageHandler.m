//
//  UnavailableImageHandler.m
//  photoRexplore
//
//  Created by Ali Nouri on 11/24/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "UnavailableImageHandler.h"
#import "UINetImageView.h"
#import "AppDelegate.h"

static UIImage* unavailableImage4x3; 
static UIImage* unavailableImageLandscape; 


@implementation UnavailableImageHandler
@synthesize failedFlag=_failedFlag; 
@synthesize imageView=_imageView; 

-(id) initWithImageView:(UINetImageView *)image
{
    self = [super initWithFrame:image.frame]; 
    if (self) 
    {
        _imageView = image; 
        image.image = [self getUnavailableImage]; 
        
        self.backgroundColor = [UIColor clearColor]; 
        
    }
    
    return self; 
}


//should be subclassed!
-(UIImage*) getUnavailableImage
{
    return nil; 
}

//need to be subclassed
-(void) drawRect:(CGRect)rect
{
    
}

@end



@implementation UnavailableImageHandlerLandscape

-(UIImage*) getUnavailableImage
{
    if (unavailableImageLandscape == nil) 
    {
        NSString* name = [( (AppDelegate*)[UIApplication sharedApplication].delegate) getImageName:@"noimageLandscape" isResolutionSensitive:YES];
        unavailableImageLandscape = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]] retain];
    }
    return unavailableImageLandscape; 
}


-(void) drawRect:(CGRect)rect
{
     
    //draw the partial sun 

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    
    //location of sun in iphones
    CGPoint center = CGPointMake(98, (self.bounds.size.height - 320)/2 + 87);
    CGFloat radius = 26;
    
    //change values for ipad
    if (self.bounds.size.width == 768)
    {
        center = CGPointMake(235, 338);
        radius = 67;
    }
    
    CGFloat degree = 2*M_PI*self.imageView.percentageDataAvailable;
    UIBezierPath*    p = [UIBezierPath bezierPath];
    
    [p moveToPoint:center]; 
    [p addLineToPoint:CGPointMake(center.x, center.y-radius)]; 
    [p addArcWithCenter:center radius:radius startAngle:-M_PI_2 endAngle:(-M_PI_2+degree) clockwise:YES]; 
    [p closePath]; 
    
    p.lineWidth = 5; 
    
//    p.usesEvenOddFillRule = YES; 
    [p fill]; 
}


@end




@implementation UnavailableImageHandler4x3


-(void) drawRect:(CGRect)rect
{
    
    if (self.imageView.failedToLoad)
    {
//        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect b = self.bounds; 
        CGRect rect = CGRectMake((b.size.width-48)/2, (b.size.height-48)/2, 48, 48);
        [[UIImage imageNamed:@"warning.png"] drawInRect:rect];     
    }
    
    [super drawRect:rect]; 
    
}


-(UIImage*) getUnavailableImage
{
    if (unavailableImage4x3 == nil) 
    {
       unavailableImage4x3 = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noimage4x3" ofType:@"png"]  ] retain]; 
    }
    return unavailableImage4x3; 
}


@end