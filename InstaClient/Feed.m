//
//  Feed.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "Feed.h"

@implementation Feed

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super initWithDictionary:dictionary];
	if (self) {
		self.userName = [dictionary valueOrNilForKeyPath:@"caption.from.username"];
		self.userID = [dictionary valueOrNilForKeyPath:@"caption.from.id"];
		
		NSString *profilePicture = [dictionary valueOrNilForKeyPath:@"caption.from.profile_picture"];
		self.profilePictureURL = [NSURL URLWithString:profilePicture];
		
		self.ID = [dictionary valueOrNilForKeyPath:@"caption.id"];
		
		NSString *lowResolution = [dictionary valueOrNilForKeyPath:@"images.low_resolution.url"];
		self.lowResolutionURL = [NSURL URLWithString:lowResolution];
		NSString *standardResolution = [dictionary valueOrNilForKeyPath:@"images.standard_resolution.url"];
		self.standardResolutionURL = [NSURL URLWithString:standardResolution];
		NSString *thumbnail = [dictionary valueOrNilForKeyPath:@"images.thumbnail.url"];
		self.thumbnailURL = [NSURL URLWithString:thumbnail];
	}
	return self;
}

@end
