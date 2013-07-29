//
//  LikesViewController.h
//  InstaClient
//
//  Created by Vitaly on 29.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feed;

@interface LikesViewController : UITableViewController
@property(nonatomic, strong) Feed *feed;
@end
