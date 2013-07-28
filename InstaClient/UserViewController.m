//
//  UserViewController.m
//  InstaClient
//
//  Created by Vitaly on 28.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "UserViewController.h"
#import "Feed.h"
#import "User.h"
#import "InstagramClient.h"
#import "NSDictionary+VPObjectOrNil.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *mediaCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *followedByCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *followsCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *bioLbl;
@property (weak, nonatomic) IBOutlet UILabel *webSiteLbl;

@property (weak, nonatomic) UIActivityIndicatorView *indicator;
@end

@implementation UserViewController

- (id)initWithDefaultNib {
	self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	User *user = self.feed.user;
	self.title = user.userName;
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:indicator];
	self.indicator = indicator;
	self.navigationItem.rightBarButtonItem = item;
	
	self.tableView.tableFooterView = [UIView new];
	[self updateView];
	[self refresh:nil];
}

- (void)refresh:(id)sender {
	[self.indicator startAnimating];
	[[InstagramClient sharedClient] getUserInfoForUserID:self.feed.userID block:^(id responseObject, NSError *error) {
		[self.indicator stopAnimating];
		if (error) {
			NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
		} else {
			NSDictionary *result = [((NSDictionary *)responseObject) vp_valueOrNilForKeyPath:@"data"];
			User *user = [[User alloc] initWithDictionary:result];
			self.feed.user = user;
			[self updateView];
		}
	}];
}

- (void)updateView {
	User *user = self.feed.user;
	[self.profileView setImageWithURL:user.profilePictureURL placeholderImage:[UIImage imageNamed:@"PhotoPlaceholder.jpg"]];
	self.mediaCountLbl.text = [user.mediaCount stringValue];
	self.followedByCountLbl.text = [user.followedByCount stringValue];
	self.followsCountLbl.text = [user.followsCount stringValue];
	self.fullNameLbl.text = user.fullName;
	self.bioLbl.text = user.bio;
	self.webSiteLbl.text = user.webSite;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	// Configure the cell...

	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)viewDidUnload {
	[self setProfileView:nil];
	[self setMediaCountLbl:nil];
	[self setFollowedByCountLbl:nil];
	[self setFollowsCountLbl:nil];
	[self setFullNameLbl:nil];
	[self setBioLbl:nil];
	[self setWebSiteLbl:nil];
	[super viewDidUnload];
}
@end
