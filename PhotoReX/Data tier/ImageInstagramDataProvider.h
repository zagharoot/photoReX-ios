//
//  ImageInstagramDataProvider.h
//  photoReX
//
//  Created by Ali Nouri on 11/12/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDataProviderManager.h"


@interface ImageInstagramDataProvider : ImageDataProvider <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableDictionary* connections; //this is a dictionary from NSURLConnection to observers.
}

-(id) init; 


@end
