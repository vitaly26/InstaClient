//
//  FeedCell.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "FeedCell.h"

static NSNumber *cellHeight;
static NSString *cellIdentificator;

@interface FeedCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

- (IBAction)pressedLikeButton:(id)sender;

@end

@implementation FeedCell

+ (void)loadParameters {
	NSString *nibName = NSStringFromClass(self);
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	UITableViewCell *cell = [objects objectAtIndex:0];
	
	cellHeight = [[NSNumber numberWithFloat:cell.bounds.size.height] copy];
	cellIdentificator = [cell.reuseIdentifier copy];
}

+ (FeedCell *)cell {
	NSString *nibName = NSStringFromClass(self);
	NSArray *objects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	FeedCell *cell = [objects objectAtIndex:0];
	return cell;
}

+ (CGFloat)heightForCell {
	if (cellHeight == nil) {
		[self loadParameters];
	}
	return [cellHeight floatValue];
}

+ (NSString *)reuseIdentifier {
	if (cellIdentificator == nil) {
		[self loadParameters];
	}
	return cellIdentificator;
}

- (void)setFeed:(Feed *)feed {
	_feed = feed;
	
	self.userName.text = feed.userName;
	[self.profilePicture setImageWithURL:feed.profilePictureURL placeholderImage:[UIImage imageNamed:@"PhotoPlaceholder.jpg"]];
	[self.pictureView setImageWithURL:feed.standardResolutionURL placeholderImage:[UIImage imageNamed:@"PhotoPlaceholder.jpg"]];
	self.likeBtn.selected = [feed.userHasLiked boolValue];
	
	[self setNeedsLayout];
}

- (void)setLike:(BOOL)like {
	self.likeBtn.selected = like;
}

- (IBAction)pressedLikeButton:(id)sender {
	if ([self.delegate respondsToSelector:@selector(didPressedLikeButtonInCell:)]) {
		[self.delegate didPressedLikeButtonInCell:self];
	}
}
@end
