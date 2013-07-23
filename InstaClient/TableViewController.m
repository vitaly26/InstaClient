//
//  TableViewController.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "TableViewController.h"
#import "ODRefreshControl.h"

@interface TableViewController ()
@property(nonatomic, retain) ODRefreshControl *odRefreshControl;
@end

static BOOL isAvailableUIRefreshControl(void) {
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0f) {
		return YES;
	} else {
		return NO;
	}
}

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		[self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self configure];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self configure];
    }
    return self;
}

- (void)configure {
	self.needUpdateData = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if (isAvailableUIRefreshControl()) {
		UIRefreshControl *refreshControl = [UIRefreshControl new];
		[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
		self.refreshControl = refreshControl;
	} else {
		ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
		[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
		self.odRefreshControl = refreshControl;
	}
}

- (void)viewDidUnload {
	self.odRefreshControl = nil;
	[super viewDidUnload];
}

- (void)refresh:(id)sender {
	[NSException raise:@"DATTableViewControllerException" format:@"%@ must be overridden", NSStringFromSelector(_cmd)];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (self.needUpdateData) {
		self.needUpdateData = NO;
		[self refresh:nil];
	}
}

- (void)beginRefreshing {
	if (isAvailableUIRefreshControl()) {
		[self.refreshControl beginRefreshing];
	} else {
		[self.odRefreshControl beginRefreshing];
	}
}

- (void)endRefreshing {
	if (isAvailableUIRefreshControl()) {
		[self.refreshControl endRefreshing];
	} else {
		[self.odRefreshControl endRefreshing];
	}
}

- (BOOL)isRefreshing {
	BOOL result;
	if (isAvailableUIRefreshControl()) {
		result = self.refreshControl.refreshing;
	} else {
		result = self.odRefreshControl.refreshing;
	}
	return result;
}

#pragma mark - Autorotate methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	} else {
		return YES;
	}
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return UIInterfaceOrientationMaskAllButUpsideDown;
	} else {
		return UIInterfaceOrientationMaskAll;
	}
}

#pragma mark -


@end
