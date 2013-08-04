//
//  InstaClientDataModel.h
//  InstaClient
//
//  Created by Vitaly on 04.08.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstaClientDataModel : NSObject
@property(nonatomic, strong, readonly) NSManagedObjectContext *mainContext;
@property(nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (InstaClientDataModel *)sharedDataModel;

@end
