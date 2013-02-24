//
//  GraphChildCategory.h
//  photoReX
//
//  Created by Ali Nouri on 2/22/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureInfo.h"


#define NUMBER_OF_PICS_FOR_CATEGORY 3       //number of pictures to retrieve for each category (in the summary view) 


@interface GraphChildCategory : NSObject
{
    PictureInfoDetails* _picInfoDetail;
}

-(NSString*) description; //should be implemented by each class 


@property (assign, nonatomic) PictureInfoDetails* picInfoDetail; 

@end





@interface GraphSameUserCategory : GraphChildCategory


@end


@interface GraphUserFavoriteCategory: GraphChildCategory


@end


@interface GraphUserContactsCategory : GraphChildCategory

@end