//
//  LikesViewController.m
//  InstaClient
//
//  Created by Vitaly on 29.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "LikesViewController.h"
#import "Feed.h"
#import "User.h"
#import "InstagramClient.h"
#import "NSDictionary+VPObjectOrNil.h"
#import "InstaClientDataModel.h"

@interface LikesViewController ()
@property(nonatomic, readonly) NSMutableArray *data;
@property(nonatomic, weak) UIActivityIndicatorView *indicator;
@end

@implementation LikesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Понравилось:";
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:indicator];
	self.indicator = indicator;
	self.navigationItem.rightBarButtonItem = item;
	
	[self refresh:nil];
}

- (NSMutableArray *)data {
	return [NSMutableArray arrayWithArray:[self.feed.likes allObjects]];
}

- (void)refresh:(id)sender {
	[self.indicator startAnimating];
	[[InstagramClient sharedClient] getLikesForMediaID:self.feed.identificator block:^(id responseObject, NSError *error) {
		[self.indicator stopAnimating];
		if (error) {
			NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
		} else {
			NSArray *result = [((NSDictionary *)responseObject) vp_valueOrNilForKeyPath:@"data"];
			
			NSManagedObjectContext *moc = [[InstaClientDataModel sharedDataModel] mainContext];
			NSManagedObjectContext *tempMock = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
			tempMock.parentContext = moc;
			
			NSManagedObjectID *objectID = self.feed.objectID;
			[tempMock performBlock:^{
				Feed *feed = (Feed *)[tempMock objectWithID:objectID];
				[feed removeLikes:feed.likes];
				for (NSDictionary *dict in result) {
					NSString *userID = [dict vp_valueOrNilForKeyPath:@"id"];
					User *user = [User userWithID:userID usingManagedObjectContext:tempMock];
					if (user == nil) {
						user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([User class]) inManagedObjectContext:tempMock];
						[user updateWithDictionary:dict];
					}
					[feed addLikesObject:user];
				}
				[tempMock save:nil];
				[moc performBlock:^{
					[moc save:nil];
					[self.tableView reloadData];
				}];
			}];
//			NSArray *result = [((NSDictionary *)responseObject) vp_valueOrNilForKeyPath:@"data"];
//			if (self.data == nil) {
//				self.data = [NSMutableArray arrayWithCapacity:result.count];
//			} else {
//				[self.data removeAllObjects];
//			}
//			for (NSDictionary *dict in result) {
//				User *user = [[User alloc] initWithDictionary:dict];
//				[self.data addObject:user];
//			}
//			[self.tableView reloadData];
		}
	}];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
	User *user = self.data[indexPath.row];
	[cell.imageView setImageWithURL:user.profilePictureURL placeholderImage:[UIImage imageNamed:@"PhotoPlaceholder.jpg"]];
	cell.textLabel.text = user.userName;
	cell.detailTextLabel.text = user.fullName;
	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
