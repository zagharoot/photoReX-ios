//
//  PictureInfo.m
//  rlimage
//
//  Created by Ali Nouri on 7/23/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "PictureInfo.h"
#import "AccountManager.h"
#import "ImageDataProviderManager.h"

@implementation PictureInfoDetails

@synthesize website=_website; 
@synthesize title=_title; 
@synthesize subtitle=_subtitle; 
@synthesize author=_author; 
@synthesize isFavorite=_isFavorite; 
@synthesize hash=_hash; 

-(NSDictionary*) getDictionaryRepresentation
{
    return nil; 
}

-(void) dealloc
{
    self.website = NOT_AVAILABLE; 
    [super dealloc]; 
}
@end


@implementation PictureInfo

@synthesize info=_info; 
@synthesize userActivityStatus=_userActivityStatus; 


-(void) setUserActivityStatus:(ImageActivityStatus)userActivityStatus
{
    _userActivityStatus = userActivityStatus;
    
//    [self.delegate imageActivityStatusDidChange:self newStatus:userActivityStatus];
    
    //publish this to the notification center 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PictureInfoImageActivityStatusDidChange" object:self]; 
}

+(ImageResolution) CGSizeToImageResolution:(CGSize)size
{
    //TODO: make this right 
    if (size.width>300)
        return ImageResolutionFullPage;
    else
        return ImageResolutionGridThumbnail; 
}



- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.userActivityStatus = ImageActivityStatusUnknown; 
    }
    
    return self;
}

-(BOOL) isInfoDataAvailable
{
    return self.info != nil; 
}


-(void) setInfo:(PictureInfoDetails *)info
{
    [_info release]; 
    _info = [info retain]; 
    
    [_dictionaryRepresentation release];    //new data, delete old representation
    
    
//    [self.delegate imageDataDidChange]; 
    //post this to the notification center 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PictureInfoImageDataDidChange" object:self]; 
    
    
    //now that the info about the picture is available, let's try to get the details (such as title, author ...) from the website too 
    [[ImageDataProviderManager mainDataProvider] fillInDetailForPictureInfo:self]; 
}


-(void) createInfoFromJsonData:(NSDictionary *)data
{
    if (data == nil){NSLog(@"ERROR: no data was passed to createInfoFromJsonData\n"); return; }
    
    //the data contains two fields: "rectype" (a code that describes why this picture was chosen, ignored for now), "picture" (contains the data)
    
    NSDictionary* picData = [data objectForKey:@"picture"]; 
    if (picData == nil){NSLog(@"ERROR: picture  data invalid createInfoFromJsonData\n"); return; }
    
    
    NSNumber* userStatus = [picData objectForKey:@"userActivityStatus"]; 
    if (userStatus != nil) 
    {
        self.userActivityStatus = [userStatus intValue]; 
    }
    
    //now look at the website field to decide what type of object to create
    
    NSString* website = [picData objectForKey:@"website"]; 
    
    
    if (website == nil){NSLog(@"ERROR: website data invalid createInfoFromJsonData\n"); return; }

    
    NSNumber* viewed = [picData objectForKey:@"isViewed"]; 
    

    if (viewed && viewed.boolValue) 
        self.userActivityStatus = ImageActivityStatusViewed; 
    
    if ([website isEqualToString:@"flickr"])
        [self setInfo:[FlickrPictureInfo infoFromJsonData:picData]]; 
    else if ([website isEqualToString:@"instagram"])
        [self setInfo:[InstagramPictureInfo infoFromJsonData:picData]]; 
    else if ([website isEqualToString:@"fiveHundredPX"])
        [self setInfo:[FiveHundredPXPictureInfo infoFromJsonData:picData]]; 
    
    //WEBSITE: add code for other websites 
}

-(NSDictionary*) dictionaryRepresentation
{
    //we create the representation lazily
    if (_dictionaryRepresentation)
        return _dictionaryRepresentation; 
    
    //not exist: create it. 
    _dictionaryRepresentation = [[self.info getDictionaryRepresentation] retain]; 

    //if we desire, we can add stuff to the dictinoary here. 
    
    //----
    
    return _dictionaryRepresentation;     
}


//change the status to visited unless the user has already marked it as disliked
-(void) makeViewed
{
    if (self.userActivityStatus != ImageActivityStatusDisliked)
    {
        self.userActivityStatus = ImageActivityStatusViewed; 
    }
}

-(void) dealloc
{
    [_info release]; 
    [_dictionaryRepresentation release]; 
    
    
    [super dealloc]; 
}


@end




//------------------------------------------
@implementation FlickrPictureInfo

@synthesize picID=_picID; 
@synthesize server = _server; 
@synthesize farm = _farm; 
@synthesize secret = _secret; 

@synthesize numberOfVisits=_numberOfVisits; 
@synthesize numberOfComments=_numberOfComments; 

-(id) initWithID:(NSString *)picID andServer:(NSString *)server andFarm:(NSString *)farm andSecret:(NSString *)secret andHash:(NSString *)hash
{
    _website = FLICKR_INDEX; 
    if (self = [super init])
    {
        _picID = [picID copy]; 
        _server = [server copy]; 
        _farm = [farm copy]; 
        _secret = [secret copy];
        _hash   = [hash copy]; 
        
        _numberOfComments=0; 
        _numberOfVisits=0; 
        _isFavorite = NO; 
    }
    return self; 
}



+(FlickrPictureInfo*) infoFromJsonData:(NSDictionary *)data
{
    NSString* p = [data objectForKey:@"id"]; 
    NSString* sr = [data objectForKey:@"server"]; 
    NSString* f = [data objectForKey:@"farm"]; 
    NSString* sc = [data objectForKey:@"secret"]; 
    NSString* h = [data objectForKey:@"hash"]; 
    
    
    if (p== nil || sr==nil || f==nil || sc==nil)
    {
        NSLog(@"ERROR: couldn't parse the data in FlickrPictureCreation"); 
        return nil; 
    }
    
    return [[[FlickrPictureInfo alloc] initWithID:p andServer:sr andFarm:f andSecret:sc andHash:h] autorelease]; 
}


-(NSDictionary*) getDictionaryRepresentation
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] initWithCapacity:5]; // we need only 4, have one for reserve :) 
    
    
    [result setValue:self.picID forKey:@"id"]; 
    [result setValue:self.server forKey:@"server"] ;
    [result setValue:self.farm forKey:@"farm"]; 
    [result setValue:self.secret forKey:@"secret"]; 
    
    
    NSDictionary* ret = [NSDictionary dictionaryWithDictionary:result]; 
    
    [result release]; 
    return ret; 
}

-(void) dealloc
{
    [_picID release];  
    [_server release]; 
    [_farm release];  
    [_secret release]; 
    
    [super dealloc]; 
    
}

@end



//---------------------------------------
@implementation InstagramPictureInfo

-(id) init
{
    self = [super init]; 
    if (self)
    {
        self.website = INSTAGRAM_INDEX; 
    }
    
    return self; 
}



+(InstagramPictureInfo*) infoFromJsonData:(NSDictionary *)data
{
    return nil; //TODO: 
}
@end



//---------------------------------------
@implementation FiveHundredPXPictureInfo


+(FiveHundredPXPictureInfo*) infoFromJsonData:(NSDictionary *)data
{
    //TODO: incomplete 
    return nil; 
    
}

@end







