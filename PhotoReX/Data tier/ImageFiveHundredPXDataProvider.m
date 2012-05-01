//
//  ImageFiveHundredPXDataProvider.m
//  photoReX
//
//  Created by Ali Nouri on 12/20/11.
//  Copyright (c) 2011 Rutgers. All rights reserved.
//

#import "ImageFiveHundredPXDataProvider.h"
#import "NetworkActivityIndicatorController.h"
#import "AccountManager.h" 
#import "ObjectiveFlickr.h" 


enum FIVEHUNDREDPX_REQUEST_TYPE {
    FIVEHUNDREDPX_USER_REQUEST = 1,
    FIVEHUNDREDPX_FAVORITE_REQUEST = 2 , 
    FIVEHUNDREDPX_UNFAVORITE_REQUEST = 3
};


@interface FiveHundredPXRequestInfo : NSObject
{
    PictureInfo* _pictureInfo; 
    id<DataDownloadObserver> _delegate; 
}

+(FiveHundredPXRequestInfo*) requestInfoWithPictureInfo:(PictureInfo*) p andRequestType:(enum FIVEHUNDREDPX_REQUEST_TYPE) r; 

+(FiveHundredPXRequestInfo*) requestUserInfo:(id<DataDownloadObserver>) observer ;

-(id) initWithPictureInfo:(PictureInfo*) p andRequestType:(enum FIVEHUNDREDPX_REQUEST_TYPE) r; 
-(id) initWithObserver:(id<DataDownloadObserver>) _delegate andRequestType:(enum FIVEHUNDREDPX_REQUEST_TYPE) r ;

@property (nonatomic, retain) PictureInfo* pictureInfo; 
@property enum FIVEHUNDREDPX_REQUEST_TYPE requestType; 
@property (nonatomic, assign) id<DataDownloadObserver> delegate; 
@end

@implementation FiveHundredPXRequestInfo
@synthesize requestType; 
@synthesize pictureInfo=_pictureInfo; 
@synthesize delegate=_delegate; 

+(FiveHundredPXRequestInfo*) requestInfoWithPictureInfo:(PictureInfo *)p andRequestType:(enum FIVEHUNDREDPX_REQUEST_TYPE)r
{
    FiveHundredPXRequestInfo* result = [[FiveHundredPXRequestInfo alloc] initWithPictureInfo:p andRequestType:r]; 
    
    return [result autorelease]; 
}


+(FiveHundredPXRequestInfo*) requestUserInfo:(id<DataDownloadObserver>)observer
{
    FiveHundredPXRequestInfo* result = [[FiveHundredPXRequestInfo alloc] initWithObserver:observer andRequestType:FIVEHUNDREDPX_USER_REQUEST]; 
                                        
    return [result autorelease];     
}


-(id) initWithPictureInfo:(PictureInfo *)p andRequestType:(enum FIVEHUNDREDPX_REQUEST_TYPE)r
{
    self = [super init]; 
    if (self)
    {
        self.requestType = r; 
        self.pictureInfo = p; 
    }
    return self; 
}

-(id) initWithObserver:(id<DataDownloadObserver>)d andRequestType:(enum FIVEHUNDREDPX_REQUEST_TYPE)r
{
    self = [super init]; 
    if (self) 
    {
        self.requestType = r; 
        self.delegate = d; 
    }
    
    return self; 
}


-(void) dealloc
{
    self.pictureInfo = nil; 
    [super dealloc]; 
}

@end 









@implementation ImageFiveHundredPXDataProvider



-(id) init
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
    //TODO: call 500pix to retrieve info about the picture 
/*       FlickrAccount* acc = [[AccountManager standardAccountManager] flickrAccount]; 
        FlickrPictureInfo* info = (FlickrPictureInfo*) pictureInfo.info; 
        OFFlickrAPIContext* context = acc.apiContext; 
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
        [request callAPIMethodWithGET:@"flickr.photos.getInfo" arguments:args]; //will get notified as delegate about the progress 
*/
}

-(BOOL) setFavorite:(BOOL)fav forPictureInfo:(PictureInfo *)pictureInfo
{
    //TODO: we need to fill this. heres flickr implementation
/*    
    FlickrAccount* acc = [[AccountManager standardAccountManager] flickrAccount]; 
    FlickrPictureInfo* info = (FlickrPictureInfo*) pictureInfo.info; 
    OFFlickrAPIContext* context = acc.apiContext; 
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
    [request callAPIMethodWithPOST:endPoint arguments:args]; //will get notified as delegate about the progress 
    return YES; 
*/
    
    return false; 
}


-(void) getDataForPicture:(PictureInfo *)pictureInfo withResolution:(ImageResolution)resolution withObserver:(id<DataDownloadObserver>)observer
{

    NSString* urlString = [self urlStringForPhotoWithInfo:pictureInfo.dictionaryRepresentation withResolution:resolution]; 
    
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
        //fill in the content-length
        det.totalBytes = response.expectedContentLength;         
    }else   //error? 
    {
        //TODO: what to do here? 
        
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
        //TODO: what to do here? 
        
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
        //TODO: what to do here? 
        
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
        //TODO: what to do here? 
    }
    
    
    //decrement network activity
    [NetworkActivityIndicatorController decrementNetworkConnections]; 
    
}


-(NSString*) urlStringForPhotoWithInfo:(NSDictionary *)info withResolution:(ImageResolution)resolution
{
	NSString *fileType = @"jpg";

	NSString* baseURL  = [info objectForKey:@"baseURL"];
	
	if (!baseURL) return nil;
	
    int resID = 3;              //this is website-specific. look at http://developers.500px.com/docs/photos-show 
	switch (resolution) {
		case ImageResolutionFullPage:     resID=4; break;
		case ImageResolutionGridThumbnail:    resID=3; break;
	}
    

	NSString* result = [NSString stringWithFormat:@"%@/%d.%@", baseURL, resID, fileType]; 
    return result; 
}	

-(void) getUserInfoForObserver:(id<DataDownloadObserver>)observer
{
    FiveHundredPXAccount* acc = [[AccountManager standardAccountManager] fiveHundredPXAccount]; 
    OFFlickrAPIContext* context = acc.apiContext; 
    OFFlickrAPIRequest* request; 
        
    request = [[OFFlickrAPIRequest alloc] initWithAPIContext:context]; 
    request.delegate = self; 
    
    NSString* endPoint = [NSString stringWithFormat:@"%@users", context.RESTAPIEndpoint];      
    request.sessionInfo = [FiveHundredPXRequestInfo requestUserInfo:observer]; 
    
    
    
    // add the request to the list of outstanding ones 
    [requests setValue:request forKey:request.description]; 
    [request release]; 
    
    NSMutableDictionary* args = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease]; 
    [args setValue:acc.api_key forKey:@"api_key"]; 
    [request callAPIMethodWithGET:endPoint arguments:args]; 
}



#pragma mark- objective flickr delegate 

-(void) flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    
    FiveHundredPXRequestInfo* sessionInfo = (FiveHundredPXRequestInfo*) inRequest.sessionInfo; 
    
    if (!sessionInfo)
        return; 
    
//    PictureInfo* pic = sessionInfo.pictureInfo;     
    id<DataDownloadObserver> observer = sessionInfo.delegate; 
    //    NSDictionary *photo, *owner, *title;  
    
    
    switch (sessionInfo.requestType) {
        case FIVEHUNDREDPX_USER_REQUEST: 
            [observer didGetUserDetails:inResponseDictionary]; 
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
    //TODO: call theBlock with the error 
    [requests removeObjectForKey:inRequest.description]; 
}



@end
