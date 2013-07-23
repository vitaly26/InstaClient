//
//  InstagramClient.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"

@interface InstagramClient : AFHTTPClient
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *token;

+ (InstagramClient *)sharedClient;
+ (NSURL *)urlForAuthentication;
+ (NSString *)redirectScheme;

- (void)getTokenWithBlock:(void (^)(NSString *token, NSError *error))block;
- (void)userFeedWithBlock:(void (^)(NSArray *feeds, NSError *error))block;

@end
