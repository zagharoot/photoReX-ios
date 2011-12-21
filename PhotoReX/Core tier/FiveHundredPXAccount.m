//
//  FifeHundredPXAccount.m
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "FiveHundredPXAccount.h"

@implementation FiveHundredPXAccount





-(UIImage*) logoImage
{
    if (_logoImage != nil)
        return _logoImage; 
    
    
    //first time use, create it: 
    NSString* path = [NSString stringWithFormat:@"%@TableCell", self.accountName ]; 
    _logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]; 
    
    return _logoImage; 
}

-(NSString*) accountName
{
    return @"fiveHundredPX"; 
}


-(BOOL) isActive
{
    return NO; //TODO: incomplete
}



-(void) loadSettings
{
    //TODO: incomplete
    [super loadSettings]; 
}

-(void) saveSettings
{
    //TODO: incomplete
    [super saveSettings]; 
}

-(NSDictionary*) dictionaryRepresentation
{
    return nil; //TODO: incomplete 
    
}

-(void) dealloc
{
    
    [super dealloc]; 
}

@end
