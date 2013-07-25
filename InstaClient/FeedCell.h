//
//  FeedCell.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@protocol FeedCellDelegate;

@interface FeedCell : UITableViewCell
@property(nonatomic, strong) Feed *feed;
@property(nonatomic, weak) id<FeedCellDelegate> delegate;

+ (FeedCell *)cell;
+ (CGFloat)heightForCell;
+ (NSString *)reuseIdentifier;

- (void)setLike:(BOOL)like;

@end

@protocol FeedCellDelegate <NSObject>
@optional
- (void)didPressedLikeButtonInCell:(FeedCell *)cell;

@end
