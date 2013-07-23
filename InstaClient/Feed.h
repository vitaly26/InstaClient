//
//  Feed.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "Model.h"

@interface Feed : Model
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSURL *profilePictureURL;
@property(nonatomic, copy) NSString *ID;
@end
