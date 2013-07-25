//
//  TablePaginator.m
//  InstaClient
//
//  Created by Vitaly on 25.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "TablePaginator.h"

#define kMoreLoadingButtonTitle @"Еще"
#define kMoreLoadingButtonTitleError @"Ошибка"

@interface TablePaginator()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation TablePaginator

- (id)initWithPaginator:(Paginator *)paginator delegate:(id<TablePaginatorDelegate>)delegate tableView:(UITableView *)tableView {
	self = [super init];
	if (self) {
		self.paginator = paginator;
		self.paginator.delegate = self;
		self.delegate = delegate;
		self.tableView = tableView;
	}
	return self;
}

- (void)setPaginator:(Paginator *)paginator {
	[_paginator cancelLoading];
	_paginator = paginator;
	_paginator.delegate = self;
}

- (void)dealloc {
	[_paginator cancelLoading];
}

- (UIView *)defaultView {
	if (self.button) {
		return self.button;
	}
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[button setTitle:kMoreLoadingButtonTitle forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(moreLoading:) forControlEvents:UIControlEventTouchUpInside];
	
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
	activityIndicator.center = CGPointMake(CGRectGetMidX(button.bounds), CGRectGetMidY(button.bounds));
	activityIndicator.color = [UIColor blackColor];
	
	[button addSubview:activityIndicator];
	
	self.activityIndicator = activityIndicator;
	self.button = button;
	return self.button;
}

- (void)startLoading {
	[self.button setTitle:@"" forState:UIControlStateNormal];
	self.button.userInteractionEnabled = NO;
	[self.activityIndicator startAnimating];
}

- (void)finishLoading {
	[self.button setTitle:kMoreLoadingButtonTitle forState:UIControlStateNormal];
	self.button.userInteractionEnabled = YES;
	[self.activityIndicator stopAnimating];
}

- (void)finishLoadingWithError:(NSError *)error {
	[self finishLoading];
	[self.button setTitle:kMoreLoadingButtonTitleError forState:UIControlStateNormal];
}

- (void)moreLoading:(id)sender {
	if (self.paginator.requestStatus != RequestStatusDone) {
		return;
	}
	[self fetchNextPage];
	if ([self.delegate respondsToSelector:@selector(paginatorDidTappedMoreButton:)]) {
		[self.delegate paginatorDidTappedMoreButton:self];
	}
}

- (void)hiddenView:(BOOL)hidden {
	self.button.hidden = hidden;
}

#pragma mark - PaginatorProtocol Methods
- (void)fetchFirstPage {
	[self finishLoading];
	[self hiddenView:YES];
	[self.paginator fetchFirstPage];
}

- (void)fetchNextPage {
	if (self.paginator.requestStatus == RequestStatusInProgress) {
		return;
	}
	[self startLoading];
	[self.paginator fetchNextPage];
}

- (void)cancelLoading {
	[self finishLoading];
	[self.paginator cancelLoading];
}

#pragma mark - Public methods
- (void)setFooterView {
	UIView *view = [self defaultView];
	if (self.paginator.requestStatus == RequestStatusNone ||
		self.paginator.reachedLastPage) {
		self.tableView.tableFooterView = [UIView new];
	} else {
		if (self.tableView.tableFooterView != view) {
			self.tableView.tableFooterView = view;
		}
	}
}

#pragma mark - NMPaginatorDelegate Methods
- (void)paginator:(Paginator *)paginator didReceiveResults:(NSArray *)results firstPage:(BOOL)isFirstPage {
	[self finishLoading];
	[self setFooterView];
	[self hiddenView:NO];
	if ([self.delegate respondsToSelector:@selector(paginator:didReceiveResults:firstPage:)]) {
		[self.delegate paginator:paginator didReceiveResults:results firstPage:isFirstPage];
	}
}

- (void)paginatorDidFailToRespond:(id)paginator error:(NSError *)error {
	[self finishLoadingWithError:(NSError *)error];
	[self hiddenView:NO];
	if ([self.delegate respondsToSelector:@selector(paginatorDidFailToRespond:error:)]) {
		[self.delegate paginatorDidFailToRespond:paginator error:error];
	}
}

#pragma mark -

@end
