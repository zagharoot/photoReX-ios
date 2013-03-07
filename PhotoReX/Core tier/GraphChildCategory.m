//
//  GraphChildCategory.m
//  photoReX
//
//  Created by Ali Nouri on 2/22/13.
//  Copyright (c) 2013 Rutgers. All rights reserved.
//

#import "GraphChildCategory.h"

@implementation GraphChildCategory

-(NSString*) description
{
    return nil;
}

@end



@implementation GraphSameUserCategory

-(NSString*) description
{
    return @"From Same User";
}

@end

@implementation GraphUserFavoriteCategory

-(NSString*) description
{
    return @"Author's Favorites";
}

@end


@implementation GraphUserContactsCategory

-(NSString*) description
{
    return @"Author's Contacts";
}
@end




