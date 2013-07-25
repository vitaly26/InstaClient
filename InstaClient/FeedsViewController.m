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
#import "PaginatorUserFeed.h"
#import "TablePaginator.h"

@interface FeedsViewController () <PaginatorDelegate, TablePaginatorDelegate, FeedCellDelegate>
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) TablePaginator *paginator;
@end

@implementation FeedsViewController

- (void)configure {
	[super configure];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHandler:) name:(NSString *)NotificationUserIsSignedIn object:nil];
	self.data = [NSMutableArray array];
	PaginatorUserFeed *paginator = [[PaginatorUserFeed alloc] initWithPageSize:0 delegate:self];
	TablePaginator *tablePaginator = [[TablePaginator alloc] initWithPaginator:paginator delegate:self tableView:nil];
	self.paginator = tablePaginator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Instagram";
	
	UIBarButtonItem *exitBtn = [[UIBarButtonItem alloc] initWithTitle:@"Выход" style:UIBarButtonItemStyleBordered target:self action:@selector(exit:)];
	self.navigationItem.rightBarButtonItem = exitBtn;
	
	self.paginator.tableView = self.tableView;
	[self.paginator setFooterView];
}

- (void)exit:(id)sender {
	
}

- (void)refresh:(id)sender {
	[self beginRefreshing];
	[self.paginator fetchFirstPage];
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
		cell.delegate = self;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == self.data.count - 1) {
		[self.paginator fetchNextPage];
	}
}

#pragma mark - PaginatorDelegate methods
- (void)paginator:(Paginator *)paginator didReceiveResults:(NSArray *)results firstPage:(BOOL)isFirstPage {
	[self endRefreshing];
	NSLog(@"results count %d", results.count);
	if (isFirstPage) {
		[self.data removeAllObjects];
	}
	[self.data addObjectsFromArray:results];
	if (isFirstPage) {
		[self.tableView reloadData];
	} else {
		NSMutableArray *indexPaths = [NSMutableArray array];
		NSInteger i = self.data.count - results.count;
		
		for (id result in results) {
			[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
			i++;
		}
		[self.tableView beginUpdates];
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
		[self.tableView endUpdates];
	}
}

- (void)paginatorDidFailToRespond:(Paginator *)paginator error:(NSError *)error {
	[self endRefreshing];
	NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - TablePaginatorDelegate methods

#pragma mark - FeedCellDelegate methods
- (void)didPressedLikeButtonInCell:(FeedCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	if (indexPath) {
		Feed *feed = self.data[indexPath.row];
		NSLog(@"%@", feed.userName);
		BOOL liked = ![feed.userHasLiked boolValue];
		feed.userHasLiked = [NSNumber numberWithBool:liked];
		[cell setLike:liked];
		[[InstagramClient sharedClient] setLike:liked forMediaID:feed.ID block:^(id responseObject, NSError *error) {
			if (error) {
				NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
				[cell setLike:!liked];
				feed.userHasLiked = [NSNumber numberWithBool:!liked];
			} else {
				NSLog(@"success %@ %@", liked ? @"like" : @"unlike", feed.userName);
			}
		}];
	}
}

@end
