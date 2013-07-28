//
//  User.h
//  InstaClient
//
//  Created by Vitaly on 28.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "Model.h"

@interface User : Model
@property(nonatomic, copy) NSString *bio;
@property(nonatomic, copy) NSString *fullName;
@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSURL *profilePictureURL;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *webSite;
@property(nonatomic, strong) NSNumber *followedByCount;
@property(nonatomic, strong) NSNumber *followsCount;
@property(nonatomic, strong) NSNumber *mediaCount;
@end
