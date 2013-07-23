//
//  TableViewController.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
@property(nonatomic, getter = isNeedUpdateData) BOOL needUpdateData;

- (void)configure;
- (void)refresh:(id)sender;//must be overridden

- (void)beginRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

@end
