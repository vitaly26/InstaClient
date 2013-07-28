//
//  Feed.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "Feed.h"
#import "User.h"

@implementation Feed

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super initWithDictionary:dictionary];
	if (self) {
		self.userName = [dictionary vp_valueOrNilForKeyPath:@"caption.from.username"];
		self.userID = [dictionary vp_valueOrNilForKeyPath:@"caption.from.id"];
		
		NSString *profilePicture = [dictionary vp_valueOrNilForKeyPath:@"caption.from.profile_picture"];
		self.profilePictureURL = [NSURL URLWithString:profilePicture];
		
		self.ID = [dictionary vp_valueOrNilForKeyPath:@"id"];
		
		NSString *lowResolution = [dictionary vp_valueOrNilForKeyPath:@"images.low_resolution.url"];
		self.lowResolutionURL = [NSURL URLWithString:lowResolution];
		NSString *standardResolution = [dictionary vp_valueOrNilForKeyPath:@"images.standard_resolution.url"];
		self.standardResolutionURL = [NSURL URLWithString:standardResolution];
		NSString *thumbnail = [dictionary vp_valueOrNilForKeyPath:@"images.thumbnail.url"];
		self.thumbnailURL = [NSURL URLWithString:thumbnail];
		
		self.userHasLiked = [dictionary vp_valueOrNilForKeyPath:@"user_has_liked"];
		self.user = [[User alloc] initWithDictionary:[dictionary vp_valueOrNilForKeyPath:@"user"]];
	}
	return self;
}

@end
