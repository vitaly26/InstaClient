//
//  _Feed.h
//  InstaClient
//
//  Created by Vitaly on 05.08.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class _User;

@interface _Feed : NSManagedObject

@property (nonatomic, retain) NSString * identificator;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) NSString * lowResolutionURLStr;
@property (nonatomic, retain) NSString * profilePictureURLStr;
@property (nonatomic, retain) NSString * standardResolutionURLSrt;
@property (nonatomic, retain) NSString * thumbnailURLStr;
@property (nonatomic, retain) NSNumber * userHasLiked;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSDate * createdTime;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) _User *user;
@end

@interface _Feed (CoreDataGeneratedAccessors)

- (void)addLikesObject:(_User *)value;
- (void)removeLikesObject:(_User *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
