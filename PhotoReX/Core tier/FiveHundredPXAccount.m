//
//  FifeHundredPXAccount.m
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "FiveHundredPXAccount.h"
#import "PictureInfo.h"

@implementation FiveHundredPXAccount
@synthesize api_key=_api_key; 
@synthesize signature=_signature; 
@synthesize requestToken=_requestToken; 
@synthesize requestSecret=_requestSecret; 
@synthesize accessToken=_accessToken; 
@synthesize accessSecret=_accessSecret; 

-(UIImage*) logoImage
{
    if (_logoImage != nil)
        return _logoImage; 
    
    
    //first time use, create it: 
    NSString* path = [NSString stringWithFormat:@"%@TableCell", self.accountName ]; 
    _logoImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:@"png"]]; 
    
    return _logoImage; 
}


-(void) setApiKey:(NSString *)key andSignature:(NSString *)signature
{
    [_api_key release]; 
    [_signature release]; 
    
    _api_key = [key copy]; 
    _signature = [signature copy]; 
    
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
