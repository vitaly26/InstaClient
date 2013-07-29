//
//  InstagramClient.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"

#define kNotificationUserIsSignedIn @"NotificationUserIsSignedIn"
#define kNotificationUserIsSignedOut @"NotificationUserIsSignedOut"

@interface InstagramClient : AFHTTPClient
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *token;

+ (InstagramClient *)sharedClient;
+ (NSURL *)urlForAuthentication;
+ (NSString *)redirectScheme;

#pragma mark - WebService's methods
- (void)getTokenWithBlock:(void (^)(NSString *token, NSError *error))block;
- (void)userFeedWithBlock:(void (^)(id responseObject, NSError *error))block;
- (void)userFeedWithMaxID:(NSString *)maxID block:(void (^)(id responseObject, NSError *error))block;
- (void)setLike:(BOOL)like forMediaID:(NSString *)ID block:(void (^)(id responseObject, NSError *error))block;
- (void)getUserInfoForUserID:(NSString *)ID block:(void (^)(id responseObject, NSError *error))block;
- (void)getLikesForMediaID:(NSString *)ID block:(void (^)(id responseObject, NSError *error))block;

#pragma mark - Cancel operations
- (void)cancelUserFeedLoading;

@end
