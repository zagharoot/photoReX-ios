//
//  ImageFlickrDataProvider.m
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "ImageFlickrDataProvider.h"
#import "NetworkActivityIndicatorController.h"
#import "AccountManager.h" 

enum FLICKR_REQUEST_TYPE {
    FLICKR_DETAIL_REQUEST = 1,
    FLICKR_FAVORITE_REQUEST = 2 , 
    FLICKR_UNFAVORITE_REQUEST = 3
    };

@interface ObjectiveFlickrRequestInfo : NSObject
{
    PictureInfo* _pictureInfo; 
}

+(ObjectiveFlickrRequestInfo*) requestInfoWithPictureInfo:(PictureInfo*) p andRequestType:(enum FLICKR_REQUEST_TYPE) r; 
-(id) initWithPictureInfo:(PictureInfo*) p andRequestType:(enum FLICKR_REQUEST_TYPE) r; 
@property (nonatomic, retain) PictureInfo* pictureInfo; 
@property enum FLICKR_REQUEST_TYPE requestType; 
@end

@implementation ObjectiveFlickrRequestInfo
@synthesize requestType; 
@synthesize pictureInfo=_pictureInfo; 

+(ObjectiveFlickrRequestInfo*) requestInfoWithPictureInfo:(PictureInfo *)p andRequestType:(enum FLICKR_REQUEST_TYPE)r
{
    ObjectiveFlickrRequestInfo* result = [[ObjectiveFlickrRequestInfo alloc] initWithPictureInfo:p andRequestType:r]; 
    
    return [result autorelease]; 
}

-(id) initWithPictureInfo:(PictureInfo *)p andRequestType:(enum FLICKR_REQUEST_TYPE)r
{
    self = [super init]; 
    if (self)
    {
        self.requestType = r; 
        self.pictureInfo = p; 
    }
    return self; 
}


-(void) dealloc
{
    self.pictureInfo = nil; 
    [super dealloc]; 
}

@end 



@implementation ImageFlickrDataProvider


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        connections = [[NSMutableDictionary alloc] init ]; 
        requests = [[NSMutableDictionary alloc] initWithCapacity:5]; 
    }
    
    return self;
}



-(void) fillInDetailForPictureInfo:(PictureInfo *)pictureInfo
{
    FlickrAccount* acc = [[AccountManager standardAccountManager] flickrAccount]; 
    FlickrPictureInfo* info = (FlickrPictureInfo*) pictureInfo.info; 
    OAuthProviderContext* context = acc.apiContext; 
    OFFlickrAPIRequest* request; 
    
    
    if (!info)      //TODO: how about register for notification to know when this does get available 
        return; 
    
    request = [[OFFlickrAPIRequest alloc] initWithAPIContext:context]; 
    request.delegate = self; 
    request.sessionInfo = [ObjectiveFlickrRequestInfo requestInfoWithPictureInfo:pictureInfo andRequestType:FLICKR_DETAIL_REQUEST]; 

    // add the request to the list of outstanding ones 
    [requests setValue:request forKey:request.description]; 
    [request release]; 
    
    NSMutableDictionary* args = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease]; 
    [args setValue:acc.api_key forKey:@"api_key"]; 
    [args setValue:info.picID forKey:@"photo_id"]; 
    
    //flickr requires method to be passed as argument and all be called on the same base url: 
    [args setValue:@"flickr.photos.getInfo" forKey:@"method"]; 
    
    [request callAPIMethodWithGET:context.RESTAPIEndpoint arguments:args]; //will get notified as delegate about the progress 
}


-(BOOL) setFavorite:(BOOL)fav forPictureInfo:(PictureInfo *)pictureInfo
{
    FlickrAccount* acc = [[AccountManager standardAccountManager] flickrAccount]; 
    FlickrPictureInfo* info = (FlickrPictureInfo*) pictureInfo.info; 
    OAuthProviderContext* context = acc.apiContext; 
    OFFlickrAPIRequest* request; 
    
    
    if (!info)      //TODO: how about register for notification to know when this does get available 
        return NO;  
    
    request = [[OFFlickrAPIRequest alloc] initWithAPIContext:context]; 
    request.delegate = self; 
    
    NSString* endPoint; 
    if (fav) 
    {
        request.sessionInfo = [ObjectiveFlickrRequestInfo requestInfoWithPictureInfo:pictureInfo andRequestType:FLICKR_FAVORITE_REQUEST]; 
        endPoint = @"flickr.favorites.add"; 
        
    }else {
        request.sessionInfo = [ObjectiveFlickrRequestInfo requestInfoWithPictureInfo:pictureInfo andRequestType:FLICKR_UNFAVORITE_REQUEST]; 
        endPoint = @"flickr.favorites.remove"; 
    }
    
    // add the request to the list of outstanding ones 
    [requests setValue:request forKey:request.description]; 
    [request release]; 
    
    NSMutableDictionary* args = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease]; 
    [args setValue:acc.api_key forKey:@"api_key"]; 
    [args setValue:info.picID forKey:@"photo_id"]; 
    [args setValue:endPoint forKey:@"method"]; 
    
    
    [request callAPIMethodWithPOST:context.RESTAPIEndpoint arguments:args]; //will get notified as delegate about the progress 
    return YES; 
}



-(void) getDataForPicture:(PictureInfo *)pictureInfo withResolution:(ImageResolution)resolution withObserver:(id<DataDownloadObserver>)observer
{

    NSString* urlString = [self urlStringForPhotoWithFlickrInfo:pictureInfo.dictionaryRepresentation withResolution:resolution]; 
    
    NSURL* url = [NSURL URLWithString:urlString]; 
    
    //create the request 
    NSURLRequest* req = [NSURLRequest requestWithURL:url]; 
    
    
    //create the connection
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:req delegate:self];
    
    //add the connection to the dictionary
    ImageDataConnectionDetails* det = [[[ImageDataConnectionDetails alloc] initWithObserver:observer] autorelease]; 
    [connections setObject:det forKey:conn.currentRequest.URL.description];  
    
    //increment network activity 
    [NetworkActivityIndicatorController incrementNetworkConnections]; 
}


-(void) dealloc
{
    [connections release]; 
    [requests release]; 
    [super dealloc]; 
}


#pragma -mark connection delegate methods 


-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    ImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
    if (det) //found the details for this connection
    {
        //fill in the content-length? 
        
        det.totalBytes = response.expectedContentLength;         
    }else   //error? 
    {
        
        
    }
    
    
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    ImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
    if (det) //found the details for this connection
    {
        //append the received data to what we already have 
        
        [det.data appendData:data]; 
        
        double percentage = 0; 
        if (det.totalBytes != 0)
            percentage = (double)det.data.length / (double) det.totalBytes; 
        
        //notify the observer of the new percentage
        if (det.observer)
        {
            if ([det.observer respondsToSelector:@selector(percentDataBecameAvailable:)])
                [det.observer percentDataBecameAvailable:percentage]; 
        }
            
    }else   //error? 
    {
        
        
    }
}


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    ImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
    if (det) //found the details for this connection
    {
        if (det.observer)
        {
            if ([det.observer respondsToSelector:@selector(imageFailedToLoad:)])
                [det.observer imageFailedToLoad:[error description]]; 
            
            
            [connections removeObjectForKey:connection.currentRequest.URL.description ];
        }
    }else   //error? 
    {
        
        
    }
    
    //decrement network activity
    [NetworkActivityIndicatorController decrementNetworkConnections]; 
    
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    ImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
    if (det) //found the details for this connection
    {
        if (det.observer)
        {
            UIImage* img = [UIImage imageWithData:det.data]; 
            [det.observer imageDidBecomeAvailable:img]; 
            
            
            //add to cache
            
            
            
            //remove the stuff from the dictionary
            [connections removeObjectForKey:connection.currentRequest.URL.description]; 
        }
    }else   //error? 
    {
    }
    
    
    //decrement network activity
    [NetworkActivityIndicatorController decrementNetworkConnections]; 
    
}



#pragma mark-working with flickr results 

-(NSString *)urlStringForPhotoWithFlickrInfo:(NSDictionary *)flickrInfo withResolution:(ImageResolution) resolution
{
	id farm = [flickrInfo objectForKey:@"farm"];
	id server = [flickrInfo objectForKey:@"server"];
	id photo_id = [flickrInfo objectForKey:@"id"];
	id secret = [flickrInfo objectForKey:@"secret"];
	NSString *fileType = @"jpg";
	
	if (!farm || !server || !photo_id || !secret) return nil;
	
	NSString *formatString = @"s";
	switch (resolution) {
		case ImageResolutionFullPage:     formatString = @"b"; break;
		case ImageResolutionGridThumbnail:     formatString = @"m"; break;
	}
    
	NSString* result =  [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
    
    return result; 
}	


#pragma mark- objective flickr delegate 

-(void) flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{

    ObjectiveFlickrRequestInfo* sessionInfo = (ObjectiveFlickrRequestInfo*) inRequest.sessionInfo; 
    
    if (!sessionInfo)
        return; 

    PictureInfo* pic = sessionInfo.pictureInfo;     
    FlickrPictureInfo* info = (FlickrPictureInfo*) pic.info; 
    NSDictionary *photo, *owner, *title;  
    
    
    switch (sessionInfo.requestType) {
        case FLICKR_DETAIL_REQUEST:
            photo = [inResponseDictionary valueForKey:@"photo"]; 
            
            if (!photo) 
                return; 
            
            owner = [photo valueForKey:@"owner"]; 
            if (owner) 
                info.author = [owner valueForKey:@"username"]; 
            
            title = [photo valueForKey:@"title"]; 
            if (title) 
                info.title = [title valueForKey:@"_text"]; 
            
            info.numberOfVisits = [[photo valueForKey:@"views"] intValue]; 
            info.isFavorite = [[photo valueForKey:@"isfavorite"] boolValue]; 
            
            NSDictionary* comments = [photo valueForKey:@"comments"]; 
            if (comments) 
                info.numberOfComments = [[comments valueForKey:@"_text"] intValue]; 
            
            break;
        case FLICKR_FAVORITE_REQUEST:
            
            [pic.info setIsFavorite:YES]; 
            break;
            
        case FLICKR_UNFAVORITE_REQUEST:
            
            [pic.info setIsFavorite:NO]; 
            break;
        default:
            break;
    }
    
    //remove the request from the outstanding list 
    [requests removeObjectForKey:inRequest.description]; 
}



-(void) flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    //remove the request from outstanding list 
    [requests removeObjectForKey:inRequest.description]; 
}

@end


