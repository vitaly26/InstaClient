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
	}
	return self;
}

@end
