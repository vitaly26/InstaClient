//
//  InstagramClient.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "InstagramClient.h"

#define InstagramURL @"https://api.instagram.com"
#define InstagramRedirectURI @"instaclient://code"
#define InstagramID @"5fcf46df12c444e4961f53964d30609b"
#define InstagramSecret @"50a8486dbb354546a700c63ba1f3942b"

#define kAccessToken @"access_token"

@implementation InstagramClient

+ (InstagramClient *)sharedClient {
    static InstagramClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[InstagramClient alloc] initWithBaseURL:[NSURL URLWithString:InstagramURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

+ (NSURL *)urlForAuthentication {
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code", InstagramID, InstagramRedirectURI]];
	return URL;
}

+ (NSString *)redirectScheme {
	NSString *scheme = [InstagramRedirectURI componentsSeparatedByString:@"://"][0];
	return scheme;
}

- (void)getTokenWithBlock:(void (^)(NSString *token, NSError *error))block {
	NSDictionary *parametes = @{@"grant_type":@"authorization_code",
							 @"code":self.code,
							 @"client_id":InstagramID,
							 @"client_secret":InstagramSecret,
							 @"redirect_uri":InstagramRedirectURI};
	[self postPath:@"oauth/access_token" parameters:parametes success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"json %@", responseObject);
		self.token = responseObject[kAccessToken];
		if (self.token) {
			if (block) {
				block(self.token, nil);
			}
		} else {
			NSLog(@"Token not found");
			if (block) {
				NSString *description = @"Токен не был получен";
				NSArray *objArray = @[description, @"Ошибка получения токена"];
				NSArray *keyArray = @[NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey];
				NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
				NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:401 userInfo:userInfo];
				block(nil, error);
			}
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"%@", error);
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)userFeedWithBlock:(void (^)(NSArray *feeds, NSError *error))block {
	NSDictionary *parameters = @{kAccessToken: self.token};
	[self getPath:@"v1/users/self/feed" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"response %@", responseObject);
		if (block) {
			block(responseObject[@"data"], nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

@end
