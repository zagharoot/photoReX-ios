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
    RLWebserviceClient* webservice;                 //this is created once, and kept with us the whole time
    NSMutableArray* _pages;                         //this is an array of PictureInfoCollection*
    NSString* _userid;                              //?    
}

-(id) initWithUserid:(NSString*) userid;                    //count is number of photos per page (note that we don't need the specific layout of the pictures) 

-(PictureInfoCollection*) retrievePageAsync:(int) howMany;        //retrieves one page of pictureInfo from the server 


@property (retain) NSMutableArray* pages;           //arrays of pictureInfoCollection
@property (copy) NSString* userid; 


@end
