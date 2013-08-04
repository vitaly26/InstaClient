//
//  Feed.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "Feed.h"
#import "User.h"
#import "NSDictionary+VPObjectOrNil.h"

@implementation Feed

+ (Feed *)feedWithID:(NSString *)ID usingManagedObjectContext:(NSManagedObjectContext *)moc {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Feed class])];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identificator LIKE %@", ID]];
	[fetchRequest setFetchLimit:1];

	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
	if (error) {
		NSLog(@"ERROR: %s %@ %@", __PRETTY_FUNCTION__, [error localizedDescription], [error userInfo]);
	}

	if ([results count] == 0) {
		return nil;
	}

	return [results objectAtIndex:0];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
	self.userName = [dictionary vp_valueOrNilForKeyPath:@"caption.from.username"];
	self.userID = [dictionary vp_valueOrNilForKeyPath:@"caption.from.id"];
	self.profilePictureURLStr = [dictionary vp_valueOrNilForKeyPath:@"caption.from.profile_picture"];
	self.identificator = [dictionary vp_valueOrNilForKeyPath:@"id"];
	self.lowResolutionURLStr = [dictionary vp_valueOrNilForKeyPath:@"images.low_resolution.url"];
	self.standardResolutionURLSrt = [dictionary vp_valueOrNilForKeyPath:@"images.standard_resolution.url"];
	self.thumbnailURLStr = [dictionary vp_valueOrNilForKeyPath:@"images.thumbnail.url"];
	self.userHasLiked = [dictionary vp_valueOrNilForKeyPath:@"user_has_liked"];
	
	if (self.user == nil) {
		NSString *userID = [dictionary vp_valueOrNilForKeyPath:@"user.id"];
		User *user = [User userWithID:userID usingManagedObjectContext:self.managedObjectContext];
		if (user == nil) {
			self.user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:self.managedObjectContext];
		} else {
			self.user = user;
		}
	}
	[((User *)self.user) updateWithDictionary:[dictionary vp_valueOrNilForKeyPath:@"user"]];
	
	self.likesCount = [dictionary vp_valueOrNilForKeyPath:@"likes.count"];

	NSString *createdTime = [dictionary vp_valueOrNilForKeyPath:@"created_time"];
	if (createdTime) {
		self.createdTime = [NSDate dateWithTimeIntervalSince1970:createdTime.integerValue];
	}
}

- (NSURL *)profilePictureURL {
	return [NSURL URLWithString:self.profilePictureURLStr];
}

- (void)setProfilePictureURL:(NSURL *)profilePictureURL {
	[self willChangeValueForKey:@"profilePictureURLStr"];
	[self setPrimitiveValue:profilePictureURL.absoluteString forKey:@"profilePictureURLStr"];
	[self didChangeValueForKey:@"profilePictureURLStr"];
}

- (NSURL *)lowResolutionURL {
	return [NSURL URLWithString:self.lowResolutionURLStr];
}

- (void)setLowResolutionURL:(NSURL *)lowResolutionURL {
	[self willChangeValueForKey:@"lowResolutionURLStr"];
	[self setPrimitiveValue:lowResolutionURL.absoluteString forKey:@"lowResolutionURLStr"];
	[self didChangeValueForKey:@"lowResolutionURLStr"];
}

- (NSURL *)standardResolutionURL {
	return [NSURL URLWithString:self.standardResolutionURLSrt];
}

- (void)setStandardResolutionURL:(NSURL *)standardResolutionURL {
	[self willChangeValueForKey:@"standardResolutionURLSrt"];
	[self setPrimitiveValue:standardResolutionURL.absoluteString forKey:@"standardResolutionURLSrt"];
	[self didChangeValueForKey:@"standardResolutionURLSrt"];
}

- (NSURL *)thumbnailURL {
	return [NSURL URLWithString:self.thumbnailURLStr];
}

- (void)setThumbnailURL:(NSURL *)thumbnailURL {
	[self willChangeValueForKey:@"thumbnailURLStr"];
	[self setPrimitiveValue:thumbnailURL.absoluteString forKey:@"thumbnailURLStr"];
	[self didChangeValueForKey:@"thumbnailURLStr"];
}

@end
