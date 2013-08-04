//
//  User.m
//  InstaClient
//
//  Created by Vitaly on 28.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "User.h"
#import "NSDictionary+VPObjectOrNil.h"

@implementation User

+ (User *)userWithID:(NSString *)ID usingManagedObjectContext:(NSManagedObjectContext *)moc {
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([User class])];
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
	self.bio = [dictionary vp_valueOrNilForKeyPath:@"bio"];
	self.fullName = [dictionary vp_valueOrNilForKeyPath:@"full_name"];
	self.identificator = [dictionary vp_valueOrNilForKeyPath:@"id"];
	self.profilePictureURLStr = [dictionary vp_valueOrNilForKeyPath:@"profile_picture"];
	self.userName = [dictionary vp_valueOrNilForKeyPath:@"username"];
	self.webSite = [dictionary vp_valueOrNilForKeyPath:@"website"];
	self.followedByCount = [dictionary vp_valueOrNilForKeyPath:@"counts.followed_by"];
	self.followsCount = [dictionary vp_valueOrNilForKeyPath:@"counts.follows"];
	self.mediaCount = [dictionary vp_valueOrNilForKeyPath:@"counts.media"];
}

- (NSURL *)profilePictureURL {
	return [NSURL URLWithString:self.profilePictureURLStr];
}

- (void)setProfilePictureURL:(NSURL *)profilePictureURL {
	[self willChangeValueForKey:@"profilePictureURLStr"];
	[self setPrimitiveValue:profilePictureURL.absoluteString forKey:@"profilePictureURLStr"];
	[self didChangeValueForKey:@"profilePictureURLStr"];
}

@end
