//
//  PagedContentProvider.h
//  photoReX
//
//  Created by Ali Nouri on 11/2/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import <Foundation/Foundation.h>


//  A protocol that provides content in the form of pages. 
//  The pages start at 0 and go to infinity. Each time we ask for a new page, it goes and gets a new page from somewhere. 
//  The method of fetching/caching is up to the implementer of the subclass. 


@protocol PagedContentProvider

-(id) getContentAtPage:(int) page; 

@end


