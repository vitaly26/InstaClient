//
//  UserViewController.h
//  InstaClient
//
//  Created by Vitaly on 28.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feed;

@interface UserViewController : UITableViewController
@property(nonatomic, strong) Feed *feed;

- (id)initWithDefaultNib;

@end
