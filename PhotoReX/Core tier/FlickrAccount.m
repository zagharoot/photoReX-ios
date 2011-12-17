//
//  FlickrAccount.m
//  rlimage
//
//  Created by Ali Nouri on 7/2/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "FlickrAccount.h"
#import "PictureInfo.h"

@implementation FlickrAccount
@synthesize frobKey=_frobKey; 





- (id)init
{
    self = [super init];
    if (self) 
    {
        [self loadSettings]; 
    }
    
    return self;
}


-(void) loadSettings
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"AccountSettings" ofType:@"plist"]; 
    NSData* data = [NSData dataWithContentsOfFile:path]; 
    
    NSString* error; 
    NSPropertyListFormat format; 
    NSDictionary* plist; 
    
    plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error]; 
    
    if (!plist) 
    {
        NSLog(@"%@", error); 
        [error release]; 
        return; 
    }
    
    NSDictionary* flickr = [plist objectForKey:self.accountName]; 
    
    
    self.frobKey = [flickr objectForKey:@"frobKey"]; 
    
    NSData* iconData =  [flickr objectForKey:@"userIconData"]; 
    
    if (iconData)
        _userIconImage = [[UIImage imageWithData:iconData] retain];     
}


-(void) saveSettings
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"AccountSettings" ofType:@"plist"]; 
    NSData* data = [NSData dataWithContentsOfFile:path]; 
    
    NSString* error; 
    NSPropertyListFormat format; 
    NSDictionary* plist; 
    
    plist = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error]; 
    
    if (!plist) 
    {
        NSLog(@"%@", error); 
        [error release]; 
        return; 
    }
    
    NSDictionary* flickr = [plist objectForKey:self.accountName]; 
    
    
    [flickr setValue:self.frobKey forKey:@"frobKey"]; 

    NSData *dataObj = UIImageJPEGRepresentation(self.userIconImage, 1.0);
    [flickr setValue:dataObj forKey:@"userIconImage"]; 
}


-(NSString*) accountName
{
    return @"flickrAccount" ; 
}


-(BOOL) isActive
{
    BOOL result =  (self.frobKey!=nil) ; 
    return result; 
}



//todo: are we handling the counts correctly here? 
-(void) setFrobKey:(NSString *)value
{
    NSLog(@"setting frobkey: %@\n", value); 
    _frobKey = value; 
}



@end
