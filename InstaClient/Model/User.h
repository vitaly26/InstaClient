//
//  User.h
//  InstaClient
//
//  Created by Vitaly on 28.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "_User.h"

@interface User : _User
@property(nonatomic, copy) NSURL *profilePictureURL;

+ (User *)userWithID:(NSString *)ID usingManagedObjectContext:(NSManagedObjectContext *)moc;

- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end
