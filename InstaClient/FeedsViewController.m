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
#import "LoginManager.h"
#import "UserViewController.h"
#import "LikesViewController.h"
#import "InstaClientDataModel.h"

@interface FeedsViewController () <PaginatorDelegate, TablePaginatorDelegate, FeedCellDelegate, NSFetchedResultsControllerDelegate>
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, strong) TablePaginator *paginator;
@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation FeedsViewController

- (void)configure {
	[super configure];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHandler:) name:kNotificationUserIsSignedIn object:nil];
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
	[[LoginManager sharedLoginManager] signOutAnimated:YES];
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

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil) {
		return _fetchedResultsController;
	}

	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Feed class])];
	[fetchRequest setFetchBatchSize:20];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTime" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptor];

	[fetchRequest setSortDescriptors:sortDescriptors];

	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																							   managedObjectContext:[[InstaClientDataModel sharedDataModel] mainContext]
																								 sectionNameKeyPath:nil
																										  cacheName:@"Master"];
	fetchedResultsController.delegate = self;
	self.fetchedResultsController = fetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	return _fetchedResultsController;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id sectionInfo = self.fetchedResultsController.sections[section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *CellIdentifier = [FeedCell reuseIdentifier];
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [FeedCell cell];
		cell.delegate = self;
    }
	Feed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.feed = feed;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [FeedCell heightForCell];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Feed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
	UserViewController *userVC = [[UserViewController alloc] initWithDefaultNib];
	userVC.feed = feed;
	[self.navigationController pushViewController:userVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	id sectionInfo = self.fetchedResultsController.sections[indexPath.section];
	if (indexPath.row == [sectionInfo numberOfObjects] - 1) {
		[self.paginator fetchNextPage];
	}
}

#pragma mark - PaginatorDelegate methods
- (void)paginator:(Paginator *)paginator didReceiveResults:(NSArray *)results firstPage:(BOOL)isFirstPage {
	[self endRefreshing];
	NSLog(@"results count %d", results.count);
	NSManagedObjectContext *moc = self.fetchedResultsController.managedObjectContext;
	NSManagedObjectContext *tempMock = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
	tempMock.parentContext = moc;
	
	if (isFirstPage) {
		NSArray *objects = self.fetchedResultsController.fetchedObjects;
		for (NSManagedObject *object in objects) {
			[moc deleteObject:object];
		}
	}
	
	[tempMock performBlock:^{
		for (NSDictionary *dict in results) {
			Feed *feed = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Feed class]) inManagedObjectContext:tempMock];
			[feed updateWithDictionary:dict];
		}
		[tempMock save:nil];
		[moc performBlock:^{
			[moc save:nil];
		}];
	}];
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
		Feed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
		NSLog(@"%@", feed.userName);
		BOOL liked = ![feed.userHasLiked boolValue];
		feed.userHasLiked = [NSNumber numberWithBool:liked];
		[cell setLike:liked];
		[[InstagramClient sharedClient] setLike:liked forMediaID:feed.identificator block:^(id responseObject, NSError *error) {
			if (error) {
				NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
				[cell setLike:!liked];
				feed.userHasLiked = [NSNumber numberWithBool:!liked];
			} else {
				NSLog(@"success %@ %@", liked ? @"like" : @"unlike", feed.userName);
			}
			NSManagedObjectContext *moc = self.fetchedResultsController.managedObjectContext;
			[moc save:nil];
		}];
	}
}

- (void)didPressedLikesButtonInCell:(FeedCell *)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	if (indexPath) {
		LikesViewController *likesVC = [[LikesViewController alloc] init];
		likesVC.feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[self.navigationController pushViewController:likesVC animated:YES];
	}
}

#pragma mark - NSFetchedResultsControllerDelegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	UITableViewRowAnimation animation = UITableViewRowAnimationFade;
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:animation];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	UITableViewRowAnimation animation = UITableViewRowAnimationNone;
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:animation];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:animation];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}


@end
