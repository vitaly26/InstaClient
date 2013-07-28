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

static NSString * const kAPIOAuth = @"/oauth/access_token";
static NSString * const kAPIUserFeed = @"/v1/users/self/feed";
static NSString * const kAPILikes = @"/v1/media/%@/likes";
static NSString * const kAPIUserInfo = @"/v1/users/%@";

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
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=likes", InstagramID, InstagramRedirectURI]];
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
	[self postPath:kAPIOAuth parameters:parametes success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)userFeedWithBlock:(void (^)(id responseObject, NSError *error))block {
	[self userFeedWithMaxID:nil block:block];
}

- (void)userFeedWithMaxID:(NSString *)maxID block:(void (^)(id responseObject, NSError *error))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[kAccessToken] = self.token;
	if (maxID) {
		parameters[@"max_id"] = maxID;
	}
	[self getPath:kAPIUserFeed parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"response %@", responseObject);
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)setLike:(BOOL)like forMediaID:(NSString *)ID block:(void (^)(id, NSError *))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[kAccessToken] = self.token;
	NSString *path = [NSString stringWithFormat:kAPILikes, ID];
	NSString *method = like ? @"POST" : @"DELETE";
	NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"response %@", responseObject);
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
	[self enqueueHTTPRequestOperation:operation];
}

- (void)getUserInfoForUserID:(NSString *)ID block:(void (^)(id, NSError *))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[kAccessToken] = self.token;
	NSString *path = [NSString stringWithFormat:kAPIUserInfo, ID];
	[self getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"response %@", responseObject);
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

#pragma mark - Cancel operations
- (void)cancelUserFeedLoading {
	[self cancelAllHTTPOperationsWithMethod:@"GET" path:kAPIUserFeed];
}

@end
