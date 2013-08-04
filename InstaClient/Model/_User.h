//
//  _User.h
//  InstaClient
//
//  Created by Vitaly on 05.08.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class _Feed;

@interface _User : NSManagedObject

@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * followedByCount;
@property (nonatomic, retain) NSNumber * followsCount;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * identificator;
@property (nonatomic, retain) NSNumber * mediaCount;
@property (nonatomic, retain) NSString * profilePictureURLStr;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * webSite;
@property (nonatomic, retain) NSSet *feeds;
@property (nonatomic, retain) _Feed *likes;
@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addFeedsObject:(_Feed *)value;
- (void)removeFeedsObject:(_Feed *)value;
- (void)addFeeds:(NSSet *)values;
- (void)removeFeeds:(NSSet *)values;

@end
