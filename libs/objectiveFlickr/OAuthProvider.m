//
//  This class provides OAuth authentication and call wrapper. It is based on objectiveFlickr implementation by:
// Copyright (c) 2009 Lukhnos D. Liu (http://lukhnos.org)
//


#import "OAuthProvider.h"
#import "OFUtilities.h"
#import "OFXMLMapper.h"
#import "SBJson.h" 

NSString *const OAuthReadPermission = @"read";
NSString *const OAuthWritePermission = @"write";
NSString *const OAuthDeletePermission = @"delete";

 
NSString *const OAuthReturnedErrorDomain = @"com.webservice";
NSString *const OAuthRequestErrorDomain = @"edu.nouri.photoReX";

NSString *const OAuthErrorUserInfoKey = @"OAuthError";
NSString *const OFFetchOAuthRequestTokenSession = @"FetchOAuthRequestToken";
NSString *const OFFetchOAuthAccessTokenSession = @"FetchOAuthAccessToken";

static NSString *const kEscapeChars = @"`~!@#$^&*()=+[]\\{}|;':\",/<>?";



@interface OAuthProviderContext (PrivateMethods)
- (NSArray *)signedArgumentComponentsFromArguments:(NSDictionary *)inArguments useURIEscape:(BOOL)inUseEscape;
- (NSString *)signedQueryFromArguments:(NSDictionary *)inArguments;
@end

@implementation OAuthProviderContext
- (void)dealloc
{
    [key release];
    [sharedSecret release];
    [authToken release];
    
    [RESTAPIEndpoint release];
	[authEndpoint release];
    
    [oauthToken release];
    [oauthTokenSecret release];
    
    [super dealloc];
}

- (id)initWithAPIKey:(NSString *)inKey sharedSecret:(NSString *)inSharedSecret authEndPoint:(NSString*)aep
restEndPoint:(NSString *)rep
{
    if ((self = [super init])) {
        key = [inKey copy];
        sharedSecret = [inSharedSecret copy];
        
        RESTAPIEndpoint = rep; 
		authEndpoint = aep; 
        
        self.messageType = @"XML"; 
    }
    return self;
}

- (void)setAuthToken:(NSString *)inAuthToken
{
    NSString *tmp = authToken;
    authToken = [inAuthToken copy];
    [tmp release];
}

- (NSString *)authToken
{
    return authToken;
}

- (NSURL *)userAuthorizationURLWithRequestToken:(NSString *)inRequestToken requestedPermission:(NSString *)inPermission
{
    NSString *perms = @"";
    
    if ([inPermission length] > 0) {
        perms = [NSString stringWithFormat:@"&perms=%@", inPermission];
    }
    
    NSString *URLString = [NSString stringWithFormat:@"%@authorize?oauth_token=%@%@",self.authEndpoint, inRequestToken, perms];
    return [NSURL URLWithString:URLString];
}

- (void)setRESTAPIEndpoint:(NSString *)inEndpoint
{
    NSString *tmp = RESTAPIEndpoint;
    RESTAPIEndpoint = [inEndpoint copy];
    [tmp release];
}

- (NSString *)RESTAPIEndpoint
{
    return RESTAPIEndpoint;
}


- (void)setAuthEndpoint:(NSString *)inEndpoint
{
	NSString *tmp = authEndpoint;
	authEndpoint = [inEndpoint copy];
	[tmp release];
}

- (NSString *)authEndpoint
{
	return authEndpoint;
}


- (void)setOAuthToken:(NSString *)inToken
{
    NSString *tmp = oauthToken;
    oauthToken = [inToken copy];
    [tmp release];    
}

- (NSString *)OAuthToken
{
    return oauthToken;
}

- (void)setOAuthTokenSecret:(NSString *)inSecret;
{
    NSString *tmp = oauthTokenSecret;
    oauthTokenSecret = [inSecret copy];
    [tmp release];    
}

- (NSString *)OAuthTokenSecret
{
    return oauthTokenSecret;
}

@synthesize key;
@synthesize sharedSecret;
@synthesize messageType; 
@end

@implementation OAuthProviderContext (PrivateMethods)
- (NSArray *)signedArgumentComponentsFromArguments:(NSDictionary *)inArguments useURIEscape:(BOOL)inUseEscape
{
    NSMutableDictionary *newArgs = [NSMutableDictionary dictionaryWithDictionary:inArguments];
	if ([key length]) {
		[newArgs setObject:key forKey:@"api_key"];
	}
	
	if ([authToken length]) {
		[newArgs setObject:authToken forKey:@"auth_token"];
	}
	
	// combine the args
	NSMutableArray *argArray = [NSMutableArray array];
	NSMutableString *sigString = [NSMutableString stringWithString:[sharedSecret length] ? sharedSecret : @""];
	NSArray *sortedArgs = [[newArgs allKeys] sortedArrayUsingSelector:@selector(compare:)];
	NSEnumerator *argEnumerator = [sortedArgs objectEnumerator];
	NSString *nextKey;
	while ((nextKey = [argEnumerator nextObject])) {
		NSString *value = [newArgs objectForKey:nextKey];
		[sigString appendFormat:@"%@%@", nextKey, value];
		[argArray addObject:[NSArray arrayWithObjects:nextKey, (inUseEscape ? OFEscapedURLStringFromNSString(value) : value), nil]];
	}
	
	NSString *signature = OFMD5HexStringFromNSString(sigString);    
    [argArray addObject:[NSArray arrayWithObjects:@"api_sig", signature, nil]];
	return argArray;
}


- (NSString *)signedQueryFromArguments:(NSDictionary *)inArguments
{
    NSArray *argComponents = [self signedArgumentComponentsFromArguments:inArguments useURIEscape:YES];
    NSMutableArray *args = [NSMutableArray array];
    NSEnumerator *componentEnumerator = [argComponents objectEnumerator];
    NSArray *nextArg;
    while ((nextArg = [componentEnumerator nextObject])) {
        [args addObject:[nextArg componentsJoinedByString:@"="]];
    }
    
    return [args componentsJoinedByString:@"&"];
}

- (NSDictionary *)signedOAuthHTTPQueryArguments:(NSDictionary *)inArguments baseURL:(NSURL *)inURL method:(NSString *)inMethod
{
    NSMutableDictionary *newArgs = [NSMutableDictionary dictionaryWithDictionary:inArguments];
    [newArgs setObject:[OFGenerateUUIDString() substringToIndex:8] forKey:@"oauth_nonce"];
    [newArgs setObject:[NSString stringWithFormat:@"%lu", (long)[[NSDate date] timeIntervalSince1970]] forKey:@"oauth_timestamp"];
    [newArgs setObject:@"1.0" forKey:@"oauth_version"];
    [newArgs setObject:@"HMAC-SHA1" forKey:@"oauth_signature_method"];
    [newArgs setObject:key forKey:@"oauth_consumer_key"];
    
    if (![inArguments objectForKey:@"oauth_token"] && oauthToken) {
        [newArgs setObject:oauthToken forKey:@"oauth_token"];
    }
    
    NSString *signatureKey = nil;
    if (oauthTokenSecret) {
        signatureKey = [NSString stringWithFormat:@"%@&%@", sharedSecret, oauthTokenSecret];
    }
    else {
        signatureKey = [NSString stringWithFormat:@"%@&", sharedSecret];
    }
    
    NSMutableString *baseString = [NSMutableString string];
    [baseString appendString:inMethod];
    [baseString appendString:@"&"];
    [baseString appendString:OFEscapedURLStringFromNSStringWithExtraEscapedChars([inURL absoluteString], kEscapeChars)];
    
    NSArray *sortedArgKeys = [[newArgs allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [baseString appendString:@"&"];
    
    NSMutableArray *baseStrArgs = [NSMutableArray array];
    NSEnumerator *kenum = [sortedArgKeys objectEnumerator];
    NSString *k;
    while ((k = [kenum nextObject]) != nil) {
        [baseStrArgs addObject:[NSString stringWithFormat:@"%@=%@", k, OFEscapedURLStringFromNSStringWithExtraEscapedChars([newArgs objectForKey:k], kEscapeChars)]];
    }
    
    [baseString appendString:OFEscapedURLStringFromNSStringWithExtraEscapedChars([baseStrArgs componentsJoinedByString:@"&"], kEscapeChars)];
    
    NSString *signature = OFHMACSha1Base64(signatureKey, baseString);
    
    [newArgs setObject:signature forKey:@"oauth_signature"];
    return newArgs;
}

- (NSURL *)oauthURLFromBaseURL:(NSURL *)inURL method:(NSString *)inMethod arguments:(NSDictionary *)inArguments
{
    NSDictionary *newArgs = [self signedOAuthHTTPQueryArguments:inArguments baseURL:inURL method:inMethod];
    NSMutableArray *queryArray = [NSMutableArray array];

    NSEnumerator *kenum = [newArgs keyEnumerator];
    NSString *k;
    while ((k = [kenum nextObject]) != nil) {
        [queryArray addObject:[NSString stringWithFormat:@"%@=%@", k, OFEscapedURLStringFromNSStringWithExtraEscapedChars([newArgs objectForKey:k], kEscapeChars)]];
    }
    
    
    NSString *newURLStringWithQuery = [NSString stringWithFormat:@"%@?%@", [inURL absoluteString], [queryArray componentsJoinedByString:@"&"]];
    
    return [NSURL URLWithString:newURLStringWithQuery];
}
@end

@implementation OAuthProviderRequest
- (void)dealloc
{
    [context release];
    [HTTPRequest release];
    [sessionInfo release];
    
    [super dealloc];
}

- (id)initWithAPIContext:(OAuthProviderContext *)inContext
{
    if ((self = [super init])) {
        context = [inContext retain];
        
        HTTPRequest = [[LFHTTPRequest alloc] init];
        [HTTPRequest setDelegate:self];
    }
    
    return self;
}

- (OAuthProviderContext *)context
{
	return context;
}

- (OAuthRequestDelegateType)delegate
{
    return delegate;
}

- (void)setDelegate:(OAuthRequestDelegateType)inDelegate
{
    delegate = inDelegate;
}

- (id)sessionInfo
{
    return [[sessionInfo retain] autorelease];
}

- (void)setSessionInfo:(id)inInfo
{
    id tmp = sessionInfo;
    sessionInfo = [inInfo retain];
    [tmp release];
}

- (NSTimeInterval)requestTimeoutInterval
{
    return [HTTPRequest timeoutInterval];
}

- (void)setRequestTimeoutInterval:(NSTimeInterval)inTimeInterval
{
    [HTTPRequest setTimeoutInterval:inTimeInterval];
}

- (BOOL)isRunning
{
    return [HTTPRequest isRunning];
}

- (void)cancel
{
    [HTTPRequest cancelWithoutDelegateMessage];
}

- (BOOL)fetchOAuthRequestTokenWithCallbackURL:(NSURL *)inCallbackURL
{
    if ([HTTPRequest isRunning]) {
        return NO;
    }

    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[inCallbackURL absoluteString], @"oauth_callback", nil];
    
    NSString* endPoint = [NSString stringWithFormat:@"%@request_token", self.context.authEndpoint]; 
    
    NSURL *requestURL = [context oauthURLFromBaseURL:[NSURL URLWithString:endPoint] method:LFHTTPRequestGETMethod arguments:paramsDictionary];
    [HTTPRequest setSessionInfo:OFFetchOAuthRequestTokenSession];
    [HTTPRequest setContentType:nil];
    return [HTTPRequest performMethod:LFHTTPRequestGETMethod onURL:requestURL withData:nil];
}

- (BOOL)fetchOAuthAccessTokenWithRequestToken:(NSString *)inRequestToken verifier:(NSString *)inVerifier
{
    if ([HTTPRequest isRunning]) {
        return NO;
    }
    NSDictionary *paramsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:inRequestToken, @"oauth_token", inVerifier, @"oauth_verifier", nil];
    
    NSString* endPoint = [NSString stringWithFormat:@"%@access_token", self.context.authEndpoint]; 
    
    NSURL *requestURL = [context oauthURLFromBaseURL:[NSURL URLWithString:endPoint] method:LFHTTPRequestGETMethod arguments:paramsDictionary];
    [HTTPRequest setSessionInfo:OFFetchOAuthAccessTokenSession];
    [HTTPRequest setContentType:nil];
    return [HTTPRequest performMethod:LFHTTPRequestGETMethod onURL:requestURL withData:nil];
}

- (BOOL)callAPIMethodWithGET:(NSString *)baseURL arguments:(NSDictionary *)inArguments
{
    if ([HTTPRequest isRunning]) {
        return NO;
    }
    
    // combine the parameters 
//	NSMutableDictionary *newArgs = inArguments ? [NSMutableDictionary dictionaryWithDictionary:inArguments] : [NSMutableDictionary dictionary];
//	[newArgs setObject:inMethodName forKey:@"method"];	

    NSURL *requestURL = nil;
    if ([context OAuthToken] && [context OAuthTokenSecret]) {
        requestURL = [context oauthURLFromBaseURL:[NSURL URLWithString:baseURL] method:LFHTTPRequestGETMethod arguments:inArguments];
    }
    else {
        NSString *query = [context signedQueryFromArguments:inArguments];
        NSString *URLString = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        requestURL = [NSURL URLWithString:URLString];
    }
    
    if (requestURL) {
        [HTTPRequest setContentType:nil];
        return [HTTPRequest performMethod:LFHTTPRequestGETMethod onURL:requestURL withData:nil];        
    }
    return NO;
}

- (BOOL)callAPIMethodWithDELETE:(NSString *)baseURL arguments:(NSDictionary *)inArguments
{
    if ([HTTPRequest isRunning]) {
        return NO;
    }
    
    // combine the parameters
    //	NSMutableDictionary *newArgs = inArguments ? [NSMutableDictionary dictionaryWithDictionary:inArguments] : [NSMutableDictionary dictionary];
    //	[newArgs setObject:inMethodName forKey:@"method"];
    
    NSURL *requestURL = nil;
    if ([context OAuthToken] && [context OAuthTokenSecret]) {
        requestURL = [context oauthURLFromBaseURL:[NSURL URLWithString:baseURL] method:LFHTTPRequestDELETEMethod arguments:inArguments];
    }
    else {
        NSString *query = [context signedQueryFromArguments:inArguments];
        NSString *URLString = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        requestURL = [NSURL URLWithString:URLString];
    }
    
    if (requestURL) {
        [HTTPRequest setContentType:nil];
        return [HTTPRequest performMethod:LFHTTPRequestDELETEMethod onURL:requestURL withData:nil];
    }
    return NO;
}


static NSData *NSDataFromOAuthPreferredWebForm(NSDictionary *formDictionary)
{
    NSMutableString *combinedDataString = [NSMutableString string];
    NSEnumerator *enumerator = [formDictionary keyEnumerator];
    
    id key = [enumerator nextObject];
    if (key) {
        id value = [formDictionary objectForKey:key];
        [combinedDataString appendString:[NSString stringWithFormat:@"%@=%@", 
                                          [(NSString*)key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                          OFEscapedURLStringFromNSStringWithExtraEscapedChars(value, kEscapeChars)]];
        
		while ((key = [enumerator nextObject])) {
			value = [formDictionary objectForKey:key];
			[combinedDataString appendString:[NSString stringWithFormat:@"&%@=%@", [(NSString*)key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], OFEscapedURLStringFromNSStringWithExtraEscapedChars(value, kEscapeChars)]];
		}
	}
    
    return [combinedDataString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];    
}

- (BOOL)callAPIMethodWithPOST:(NSString *)baseURL arguments:(NSDictionary *)inArguments
{
    if ([HTTPRequest isRunning]) {
        return NO;
    }
    
    
    NSData *postData = nil;
    
    if ([context OAuthToken] && [context OAuthTokenSecret]) {
        NSDictionary *signedArgs = [context signedOAuthHTTPQueryArguments:inArguments baseURL:[NSURL URLWithString:baseURL] method:LFHTTPRequestPOSTMethod];
        
        postData = NSDataFromOAuthPreferredWebForm(signedArgs);
    }
    else {    
        NSString *arguments = [context signedQueryFromArguments:inArguments];
        postData = [arguments dataUsingEncoding:NSUTF8StringEncoding];
    }
    
	[HTTPRequest setContentType:LFHTTPRequestWWWFormURLEncodedContentType];
	return [HTTPRequest performMethod:LFHTTPRequestPOSTMethod onURL:[NSURL URLWithString:baseURL] withData:postData];
}


#pragma mark LFHTTPRequest delegate methods
- (void)httpRequestDidComplete:(LFHTTPRequest *)request
{
    if ([request sessionInfo] == OFFetchOAuthRequestTokenSession) {
        [request setSessionInfo:nil];
        
        NSString *response = [[[NSString alloc] initWithData:[request receivedData] encoding:NSUTF8StringEncoding] autorelease];

        NSDictionary *params = OFExtractURLQueryParameter(response);
        NSString *oat = [params objectForKey:@"oauth_token"];
        NSString *oats = [params objectForKey:@"oauth_token_secret"];
        if (!oat || !oats) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:response, OAuthErrorUserInfoKey, nil];
            NSError *error = [NSError errorWithDomain:OAuthRequestErrorDomain code:-1 userInfo:userInfo];            
            [delegate OAuthRequest:self didFailWithError:error];                
        }
        else {
            NSAssert([delegate respondsToSelector:@selector(OAuthRequest:didObtainOAuthRequestToken:secret:)], @"Delegate must implement the method -OAuthRequest:didObtainOAuthRequestToken:secret: to handle OAuth request token callback");
            
            [delegate OAuthRequest:self didObtainOAuthRequestToken:oat secret:oats];
        }
    }
    else if ([request sessionInfo] == OFFetchOAuthAccessTokenSession) {
        [request setSessionInfo:nil];

        NSString *response = [[[NSString alloc] initWithData:[request receivedData] encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *params = OFExtractURLQueryParameter(response);
        
        NSAssert([delegate respondsToSelector:@selector(OAuthRequest:didObtainOAuthAccessToken:)], @"Delegate must implement -OAuthRequest:didObtainOAuthAccessToken: to handle the obtained access token");
         
        [delegate OAuthRequest:self didObtainOAuthAccessToken:params]; 
    }
    else {  //regular call 
        
        if ([context.messageType isEqualToString:@"XML"])
        {
            
            //        NSString* deleteme = [[NSString alloc] initWithData:[request receivedData] encoding:NSUTF8StringEncoding]; 
            NSDictionary *responseDictionary = [OFXMLMapper dictionaryMappedFromXMLData:[request receivedData]];	
            NSDictionary *rsp = [responseDictionary objectForKey:@"rsp"];
            NSString *stat = [rsp objectForKey:@"stat"];
            
            // this also fails when (responseDictionary, rsp, stat) == nil, so it's a guranteed way of checking the result
            if (![stat isEqualToString:@"ok"]) {
                NSDictionary *err = [rsp objectForKey:@"err"];
                NSString *code = [err objectForKey:@"code"];
                NSString *msg = [err objectForKey:@"msg"];
                
                NSError *toDelegateError;
                if ([code length]) {
                    // intValue for 10.4-compatibility
                    toDelegateError = [NSError errorWithDomain:OAuthReturnedErrorDomain code:[code intValue] userInfo:[msg length] ? [NSDictionary dictionaryWithObjectsAndKeys:msg, NSLocalizedFailureReasonErrorKey, nil] : nil];				
                }
                else {
                    toDelegateError = [NSError errorWithDomain:OAuthRequestErrorDomain code:-1 userInfo:nil];
                }
                
                if ([delegate respondsToSelector:@selector(OAuthRequest:didFailWithError:)]) {
                    [delegate OAuthRequest:self didFailWithError:toDelegateError];        
                }
                return;
            }
            
            if ([delegate respondsToSelector:@selector(OAuthRequest:didCompleteWithResponse:)]) {
                [delegate OAuthRequest:self didCompleteWithResponse:rsp];
            }    
        } else if ([context.messageType isEqualToString:@"JSON"])
        {            
            SBJsonParser* parser = [[SBJsonParser alloc] init]; 
            parser.maxDepth = 6; 
            
            
            NSDictionary* responseDic = [parser objectWithData:request.receivedData]; 
            
            if ([delegate respondsToSelector:@selector(OAuthRequest:didCompleteWithResponse:)])
                [delegate OAuthRequest:self didCompleteWithResponse:responseDic];
        }

    }//regular call 
}

- (void)httpRequest:(LFHTTPRequest *)request didFailWithError:(NSString *)error
{
    NSError *toDelegateError = nil;
    if ([error isEqualToString:LFHTTPRequestConnectionError]) {
		toDelegateError = [NSError errorWithDomain:OAuthRequestErrorDomain code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network connection error", NSLocalizedFailureReasonErrorKey, nil]];
    }
    else if ([error isEqualToString:LFHTTPRequestTimeoutError]) {
		toDelegateError = [NSError errorWithDomain:OAuthRequestErrorDomain code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Request timeout", NSLocalizedFailureReasonErrorKey, nil]];
    }
    else {
		toDelegateError = [NSError errorWithDomain:OAuthRequestErrorDomain code:-1 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Unknown error", NSLocalizedFailureReasonErrorKey, nil]];
    }
    
    if ([delegate respondsToSelector:@selector(OAuthRequest:didFailWithError:)]) {
        [delegate OAuthRequest:self didFailWithError:toDelegateError];        
    }
}

- (void)httpRequest:(LFHTTPRequest *)request sentBytes:(NSUInteger)bytesSent total:(NSUInteger)total
{
    if (uploadTempFilename && [delegate respondsToSelector:@selector(OAuthRequest:imageUploadSentBytes:totalBytes:)]) {
        [delegate OAuthRequest:self imageUploadSentBytes:bytesSent totalBytes:total];
    }
}
@end

