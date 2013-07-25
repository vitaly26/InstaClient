//
//  TablePaginator.h
//  InstaClient
//
//  Created by Vitaly on 25.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paginator.h"

@protocol TablePaginatorDelegate;

@interface TablePaginator : NSObject <PaginatorProtocol, PaginatorDelegate>
@property(nonatomic, strong) Paginator *paginator;
@property(nonatomic, weak) id<TablePaginatorDelegate> delegate;
@property(nonatomic, weak) UITableView *tableView;

- (id)initWithPaginator:(Paginator *)paginator delegate:(id<TablePaginatorDelegate>)delegate tableView:(UITableView *)tableView;

- (void)setFooterView;

@end


@protocol TablePaginatorDelegate<PaginatorDelegate>
@optional
- (void)paginatorDidTappedMoreButton:(TablePaginator *)paginator;
@end