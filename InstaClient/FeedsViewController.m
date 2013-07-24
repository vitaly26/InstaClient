//
//  FeedsViewController.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "FeedsViewController.h"
#import "InstagramClient.h"
#import "Feed.h"
#import "FeedCell.h"

@interface FeedsViewController ()
@property(nonatomic, strong) NSMutableArray *data;
@end

@implementation FeedsViewController

- (void)configure {
	[super configure];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHandler:) name:(NSString *)NotificationUserIsSignedIn object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Instagram";
	
	UIBarButtonItem *exitBtn = [[UIBarButtonItem alloc] initWithTitle:@"Выход" style:UIBarButtonItemStyleBordered target:self action:@selector(exit:)];
	self.navigationItem.rightBarButtonItem = exitBtn;
}

- (void)exit:(id)sender {
	
}

- (void)refresh:(id)sender {
	[[InstagramClient sharedClient] userFeedWithBlock:^(NSArray *feeds, NSError *error) {
		[self endRefreshing];
		if (error) {
			NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
		} else {
			NSMutableArray *newFeeds = [NSMutableArray array];
			for (NSDictionary *item in feeds) {
				Feed *feed = [[Feed alloc] initWithDictionary:item];
				[newFeeds addObject:feed];
			}
			self.data = newFeeds;
			[self.tableView reloadData];
		}
	}];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateHandler:(NSNotification *)notification {
	self.needUpdateData = YES;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [FeedCell reuseIdentifier];
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [FeedCell cell];
    }
	Feed *feed = self.data[indexPath.row];
	cell.feed = feed;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [FeedCell heightForCell];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
