//
//  ExploreImageProvider.h
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PagedContentProvider.h"
#import "PictureInfoCollection.h"
#import "RLWebserviceClient.h"


@interface ExploreImageProvider : NSObject <PagedContentProvider> 
{
    RLWebserviceClient* webservice;                 //this is linked to the standard one
    NSMutableArray* _pages;                         //this is an array of PictureInfoCollection*
}


-(PictureInfoCollection*) retrievePageAsync:(int) howMany;        //retrieves one page of pictureInfo from the server 
-(void) userVisitsImageAtIndex:(int) indx inPictureInfoCollection:(PictureInfoCollection*) picCollection; 

@property (retain) NSMutableArray* pages;           //arrays of pictureInfoCollection

@end
