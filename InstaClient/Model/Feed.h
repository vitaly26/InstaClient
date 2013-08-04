//
//  Feed.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "_Feed.h"

@class User;

@interface Feed : _Feed
@property(nonatomic, copy) NSURL *profilePictureURL;
@property(nonatomic, copy) NSURL *lowResolutionURL;
@property(nonatomic, copy) NSURL *standardResolutionURL;
@property(nonatomic, copy) NSURL *thumbnailURL;

+ (Feed *)feedWithID:(NSString *)ID usingManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end
