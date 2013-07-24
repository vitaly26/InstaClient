//
//  FeedCell.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface FeedCell : UITableViewCell
@property(nonatomic, strong) Feed *feed;

+ (FeedCell *)cell;
+ (CGFloat)heightForCell;
+ (NSString *)reuseIdentifier;

@end
