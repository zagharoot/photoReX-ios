//
//  ImageFlickrDataProvider.m
//  rlimage
//
//  Created by Ali Nouri on 7/25/11.
//  Copyright 2011 Rutgers. All rights reserved.
//

#import "ImageFlickrDataProvider.h"
#import "FlickrAPIKey.h"
#import "NetworkActivityIndicatorController.h"

@interface FlickrImageDataConnectionDetails : NSObject {
    id<DataDownloadObserver> observer; 
    long totalBytes; 
    long receivedBytes; 
    NSMutableData* data; 
}

-(id) initWithObserver:(id<DataDownloadObserver>) obs; 

@property long totalBytes; 
@property long receivedBytes; 
@property (assign) id<DataDownloadObserver> observer; 
@property (assign) NSMutableData* data; 

@end

@implementation FlickrImageDataConnectionDetails

@synthesize totalBytes; 
@synthesize receivedBytes; 
@synthesize observer; 
@synthesize data; 

-(id) initWithObserver:(id<DataDownloadObserver>)obs
{
    self = [super init]; 
    if (self)
    {
        self.observer = obs; 
        data = [[NSMutableData alloc] init ];
    }
    
    return self;  
}


-(void) dealloc
{
    [data release]; 
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
    }
    
    return self;
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
    FlickrImageDataConnectionDetails* det = [[[FlickrImageDataConnectionDetails alloc] initWithObserver:observer] autorelease]; 
    [connections setObject:det forKey:conn.currentRequest.URL.description];  
    
    //increment network activity 
    [NetworkActivityIndicatorController incrementNetworkConnections]; 
}


-(void) dealloc
{
    [connections release]; 
}


#pragma -mark connection delegate methods 


-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    FlickrImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
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
    FlickrImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
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
    FlickrImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
    if (det) //found the details for this connection
    {
        if (det.observer)
        {
            if ([det.observer respondsToSelector:@selector(imageFailedToLoad:)])
                [det.observer imageFailedToLoad:[error description]]; 
            
            
            [connections removeObjectForKey:connection ];
        }
    }else   //error? 
    {
        
        
    }
    
    //decrement network activity
    [NetworkActivityIndicatorController decrementNetworkConnections]; 
    
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    FlickrImageDataConnectionDetails* det = [connections objectForKey:connection.currentRequest.URL.description]; 
    
    if (det) //found the details for this connection
    {
        if (det.observer)
        {
            UIImage* img = [UIImage imageWithData:det.data]; 
            [det.observer imageDidBecomeAvailable:img]; 
            
            
            //add to cache
            
            
            
            //remove the stuff from the dictionary
            [connections removeObjectForKey:connection]; 
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



@end


