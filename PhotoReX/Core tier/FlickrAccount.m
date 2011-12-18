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
    //read user defaults for the frobKey
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    NSDictionary* flickr = [ud valueForKey:self.accountName]; 
    
    if (!flickr) 
        return; 
    
    
    self.frobKey = [flickr objectForKey:@"frobKey"]; 
    
    NSData* iconData =  [flickr objectForKey:@"userIconData"]; 
    
    if (iconData)
        _userIconImage = [[UIImage imageWithData:iconData] retain];     
}


-(void) saveSettings
{    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 

    NSMutableDictionary* flickr = [NSMutableDictionary dictionaryWithCapacity:5]; 
    
    [flickr setValue:self.frobKey forKey:@"frobKey"]; 
        
    NSData *dataObj = UIImageJPEGRepresentation(self.userIconImage, 1.0);
    [flickr setValue:dataObj forKey:@"userIconImage"]; 
    
    
    [ud setValue:flickr forKey:self.accountName]; 
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


-(void) deactivate
{
    //TODO: inform server and flickr perhaps? 
    self.frobKey = nil; 
    self.userIconImage = nil; 
    [self saveSettings]; 
    
}




//todo: are we handling the counts correctly here? 
-(void) setFrobKey:(NSString *)value
{
    NSLog(@"setting frobkey: %@\n", value); 
    _frobKey = value; 
}



@end
