//
//  User.m
//  InstaClient
//
//  Created by Vitaly on 28.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super initWithDictionary:dictionary];
	if (self) {
		self.bio = [dictionary vp_valueOrNilForKeyPath:@"bio"];
		self.fullName = [dictionary vp_valueOrNilForKeyPath:@"full_name"];
		self.ID = [dictionary vp_valueOrNilForKeyPath:@"id"];
		
		NSString *profilePicture = [dictionary vp_valueOrNilForKeyPath:@"profile_picture"];
		self.profilePictureURL = [NSURL URLWithString:profilePicture];
		
		self.userName = [dictionary vp_valueOrNilForKeyPath:@"username"];
		self.webSite = [dictionary vp_valueOrNilForKeyPath:@"website"];
		self.followedByCount = [dictionary vp_valueOrNilForKeyPath:@"counts.followed_by"];
		self.followsCount = [dictionary vp_valueOrNilForKeyPath:@"counts.follows"];
		self.mediaCount = [dictionary vp_valueOrNilForKeyPath:@"counts.media"];
	}
	return self;
}

@end
