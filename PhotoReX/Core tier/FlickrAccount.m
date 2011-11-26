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
        //read user defaults for the frobKey
               NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
        _frobKey = [ud valueForKey:@"flickrFrobKey"]; 
        
        if (self.frobKey != nil ) //we've got a match. Now let's double check it with flickr to see if we still have access
        {
            
            
            //todo: check with flickr. if there's no access, remove the key 
            
        }
    }
    
    return self;
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
    
    //replace the value in the userdefaults
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults]; 
    
    if(_frobKey != nil) 
        [ud setValue:_frobKey forKey:@"flickrFrobKey"]; 
    else
        [ud removeObjectForKey:@"flickrFrobKey"]; 
}



@end
