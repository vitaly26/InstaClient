//
//  Feed.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "Model.h"

@class User;

@interface Feed : Model
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSURL *profilePictureURL;
@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSURL *lowResolutionURL;
@property(nonatomic, copy) NSURL *standardResolutionURL;
@property(nonatomic, copy) NSURL *thumbnailURL;
@property(nonatomic, strong) NSNumber *userHasLiked;
@property(nonatomic, strong) User *user;
@end
