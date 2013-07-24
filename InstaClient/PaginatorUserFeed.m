//
//  PaginatorUserFeed.m
//  InstaClient
//
//  Created by Vitaly on 24.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "PaginatorUserFeed.h"
#import "InstagramClient.h"
#import "NSDictionary+VPObjectOrNil.h"
#import "Feed.h"

@implementation PaginatorUserFeed

- (void)fetchResultsWithNextMaxID:(NSString *)nextMaxID pageSize:(NSInteger)pageSize {
	[[InstagramClient sharedClient] userFeedWithMaxID:nextMaxID block:^(id responseObject, NSError *error) {
		if (error) {
			[self failedWithError:error];
		} else {
			NSString *newNextMaxID = [((NSDictionary *)responseObject) vp_valueOrNilForKeyPath:@"pagination.next_max_id"];
			NSArray *results = [((NSDictionary *)responseObject) vp_valueOrNilForKeyPath:@"data"];

			NSMutableArray *feeds = [NSMutableArray array];
			for (NSDictionary *item in results) {
				Feed *feed = [[Feed alloc] initWithDictionary:item];
				[feeds addObject:feed];
			}
			[self receivedResults:feeds nextMaxID:newNextMaxID];
		}
	}];
}

- (void)cancelLoading {
	[super cancelLoading];
	[[InstagramClient sharedClient] cancelUserFeedLoading];
}

@end
