//
//  Paginator.m
//  InstaClient
//
//  Created by Vitaly on 24.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "Paginator.h"

@interface Paginator ()
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, assign) RequestStatus requestStatus;
@property(nonatomic, assign) BOOL reseted;
@property(nonatomic, assign) BOOL reachedLastPage;
@property(nonatomic, copy) NSString *nextMaxID;

@end

@implementation Paginator

- (id)initWithPageSize:(NSInteger)pageSize delegate:(id<PaginatorDelegate>)paginatorDelegate {
	if(self = [super init]) {
		[self setDefaultValues];
		self.pageSize = pageSize;
		self.delegate = paginatorDelegate;
	}
	return self;
}

- (void)dealloc {
	[self cancelLoading];
}

- (void)setDefaultValues {
	self.requestStatus = RequestStatusNone;
	self.nextMaxID = nil;
	self.reseted = YES;
	self.reachedLastPage = NO;
}

- (void)reset {
	[self setDefaultValues];
}

#pragma mark - Public methods
- (void)fetchFirstPage {
	[self cancelLoading];
	self.reseted = YES;
	[self fetchNextPage];
}

- (void)fetchNextPage {
	if (self.requestStatus == RequestStatusInProgress) {
		return;
	}

	if (!self.reachedLastPage || self.reseted) {
		self.requestStatus = RequestStatusInProgress;
		[self fetchResultsWithNextMaxID:self.nextMaxID pageSize:self.pageSize];
	}
}

- (void)cancelLoading {
	self.reseted = NO;
	self.requestStatus = RequestStatusDone;
}

#pragma mark - Sublclass methods
- (void)fetchResultsWithNextMaxID:(NSString *)nextMaxID pageSize:(NSInteger)pageSize {
}

#pragma mark - Received results
- (void)receivedResults:(NSArray *)results nextMaxID:(NSString *)nextMaxID {
	BOOL isFirstPage = NO;
	if (self.reseted) {
		[self reset];
		self.reseted = NO;
		isFirstPage = YES;
	}
	self.requestStatus = RequestStatusDone;
	self.nextMaxID = nextMaxID;
	if (nextMaxID == nil) {
		self.reachedLastPage = YES;
	}

	if ([self.delegate respondsToSelector:@selector(paginator:didReceiveResults:firstPage:)]) {
		[self.delegate paginator:self didReceiveResults:results firstPage:isFirstPage];
	}
}

- (void)failedWithError:(NSError *)error {
	self.reseted = NO;
	self.requestStatus = RequestStatusDone;
	if ([self.delegate respondsToSelector:@selector(paginatorDidFailToRespond:error:)]) {
		[self.delegate paginatorDidFailToRespond:self error:error];
	}
}

@end
