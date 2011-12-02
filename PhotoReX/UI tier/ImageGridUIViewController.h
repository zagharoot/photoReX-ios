//
//  ImageGridUIViewController.h
//  rlimage
//
//  Created by Ali Nouri on 7/10/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfinitePagedScrollView.h"
#import "UINetImageView.h"
#import "UIImageButton.h"
#import "PictureInfoCollection.h"

//TODO: we can optimize performance by caching the picture size and all the functions that are called for computing picture location ...



// if someone is using the grid viewer and wants to be notified when the user clicks on an image, it needs to comply with this protocol 
@protocol ImageGridUIActivityDelegate <NSObject>
@optional 
-(void) imageAtIndex:(int) indx selectedInPictureInfoCollection:(PictureInfoCollection*) picCollection; 
@end


@interface ImageGridUIViewController : InfiniteScrollViewContent
{
    UILabel* IBOutlet m_label; 
    
    int numberOfRows; 
    int numberOfColumns; 
    NSMutableArray* _images;
    PictureInfoCollection* _imageSource; 
    id<ImageGridUIActivityDelegate> _delegate;      //for notification of user activity
}

-(void) setup; 
-(void) loadImages; 
 
-(CGSize) getPictureSize;       //get the size of the picture based on the number of rows and cols
-(CGRect) getPictureFrameAtRow:(int) row andCol:(int) col;     
-(CGRect) getPictureFrameAtPosition:(CGPoint) pos; 
-(CGPoint) getRowAndColFromIndex:(int) index;               //converts the index pos to the row and col coordinate


-(void) showImageDetail:(UIImageButton*) imgBtn; 

@property (nonatomic, retain)  UILabel* label; 
@property (nonatomic, retain) PictureInfoCollection* imageSource; 
@property (nonatomic, retain) NSMutableArray* images; 
@property (nonatomic, assign) id<ImageGridUIActivityDelegate> delegate; 
@end
