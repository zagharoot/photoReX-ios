//
//  This class provides OAuth authentication and call wrapper. It is based on objectiveFlickr implementation by:
// Copyright (c) 2009 Lukhnos D. Liu (http://lukhnos.org)
//

#import "LFWebAPIKit.h"
#import "OFUtilities.h"
#import "OFXMLMapper.h"


extern NSString *const OAuthReadPermission;
extern NSString *const OAuthWritePermission;
extern NSString *const OAuthDeletePermission;



@interface OAuthProviderContext : NSObject
{
    NSString *key;
    NSString *sharedSecret;
    NSString *authToken;
    
    NSString *RESTAPIEndpoint;
	NSString *authEndpoint;
    
    NSString *oauthToken;
    NSString *oauthTokenSecret;
    
    NSString* _messageType;         //what is the response format from the website: JSON, XML
}
- (id)initWithAPIKey:(NSString *)inKey sharedSecret:(NSString *)inSharedSecret authEndPoint:(NSString*) authEndPoint restEndPoint:(NSString*) rep;  

// OAuth URL
- (NSURL *)userAuthorizationURLWithRequestToken:(NSString *)inRequestToken requestedPermission:(NSString *)inPermission;

// API endpoints

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_4
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *sharedSecret;
@property (nonatomic, retain) NSString *authToken;

@property (nonatomic, retain) NSString *RESTAPIEndpoint;
@property (nonatomic, retain) NSString *authEndpoint;

@property (nonatomic, retain) NSString *OAuthToken;
@property (nonatomic, retain) NSString *OAuthTokenSecret;
@property (nonatomic, copy) NSString* messageType; 
#else

- (void)setAuthToken:(NSString *)inAuthToken;
- (NSString *)authToken;


- (void)setRESTAPIEndpoint:(NSString *)inEndpoint;
- (NSString *)RESTAPIEndpoint;


- (void)setAuthEndpoint:(NSString *)inEndpoint;
- (NSString *)authEndpoint;


- (void)setOAuthToken:(NSString *)inToken;
- (NSString *)OAuthToken;

- (void)setOAuthTokenSecret:(NSString *)inTokenSecret;
- (NSString *)OAuthTokenSecret;


#endif
@end

extern NSString *const OAuthReturnedErrorDomain;
extern NSString *const OAuthRequestErrorDomain;


extern NSString *const OAuthErrorUserInfoKey;

extern NSString *const OFFetchOAuthRequestTokenSession;
extern NSString *const OFFetchOAuthAccessTokenSession;


@class OAuthProviderRequest;

@protocol OAuthRequestDelegate <NSObject>
@optional
- (void)flickrAPIRequest:(OAuthProviderRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary;
- (void)flickrAPIRequest:(OAuthProviderRequest *)inRequest didFailWithError:(NSError *)inError;
- (void)flickrAPIRequest:(OAuthProviderRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes;
- (void)flickrAPIRequest:(OAuthProviderRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret;

-(void) flickrAPIRequest:(OAuthProviderRequest *)inRequest didObtainOAuthAccessToken:(NSDictionary*) params; 
@end

typedef id<OAuthRequestDelegate> OFFlickrAPIRequestDelegateType;

@interface OAuthProviderRequest : NSObject
{
    OAuthProviderContext *context;
    LFHTTPRequest *HTTPRequest;
    
    OFFlickrAPIRequestDelegateType delegate;
    id sessionInfo;
    
    NSString *uploadTempFilename;
    
    id oauthState;
}
- (id)initWithAPIContext:(OAuthProviderContext *)inContext;
- (OAuthProviderContext *)context;


- (NSTimeInterval)requestTimeoutInterval;
- (void)setRequestTimeoutInterval:(NSTimeInterval)inTimeInterval;
- (BOOL)isRunning;
- (void)cancel;

// oauth methods
- (BOOL)fetchOAuthRequestTokenWithCallbackURL:(NSURL *)inCallbackURL;
- (BOOL)fetchOAuthAccessTokenWithRequestToken:(NSString *)inRequestToken verifier:(NSString *)inVerifier;


// elementary methods
- (BOOL)callAPIMethodWithGET:(NSString *)baseURL arguments:(NSDictionary *)inArguments;
- (BOOL)callAPIMethodWithPOST:(NSString *)baseURL arguments:(NSDictionary *)inArguments;


@property (nonatomic, readonly) OAuthProviderContext *context;
@property (nonatomic, assign) OFFlickrAPIRequestDelegateType delegate;
@property (nonatomic, retain) id sessionInfo;
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

@end
