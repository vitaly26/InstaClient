//
//  Paginator.h
//  InstaClient
//
//  Created by Vitaly on 24.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RequestStatusNone,
    RequestStatusInProgress,
    RequestStatusDone // request succeeded or failed
} RequestStatus;

@protocol PaginatorDelegate;

@interface Paginator : NSObject
@property(nonatomic, weak) id<PaginatorDelegate> delegate;
@property(nonatomic, assign, readonly) NSInteger pageSize;
@property(nonatomic, assign, readonly) RequestStatus requestStatus;
@property(nonatomic, readonly, getter = isReachedLastPage) BOOL reachedLastPage;

- (id)initWithPageSize:(NSInteger)pageSize delegate:(id<PaginatorDelegate>)paginatorDelegate;

- (void)fetchFirstPage;
- (void)fetchNextPage;
- (void)cancelLoading;

// override in subclass
- (void)fetchResultsWithNextMaxID:(NSString *)nextMaxID pageSize:(NSInteger)pageSize;

// call these from subclass when you receive the results
- (void)receivedResults:(NSArray *)results nextMaxID:(NSString *)nextMaxID;
- (void)failedWithError:(NSError *)error;

@end

@protocol PaginatorDelegate <NSObject>
@optional
- (void)paginator:(Paginator *)paginator didReceiveResults:(NSArray *)results firstPage:(BOOL)isFirstPage;
- (void)paginatorDidFailToRespond:(Paginator *)paginator error:(NSError *)error;
@end
