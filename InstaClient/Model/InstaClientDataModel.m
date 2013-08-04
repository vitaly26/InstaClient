//
//  InstaClientDataModel.m
//  InstaClient
//
//  Created by Vitaly on 04.08.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "InstaClientDataModel.h"

static NSString * const modelName = @"InstaClient";

@interface InstaClientDataModel ()
@property(nonatomic, strong) NSManagedObjectContext *mainContext;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation InstaClientDataModel

+ (InstaClientDataModel *)sharedDataModel {
	static InstaClientDataModel *_shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shared = [InstaClientDataModel new];
	});

	return _shared;
}

- (NSString *)pathToModel {
	return [[NSBundle mainBundle] pathForResource:modelName ofType:@"momd"];
}

- (NSString *)storeFilename {
	return [modelName stringByAppendingPathExtension:@"sqlite"];
}

- (NSString *)pathToLocalStore {
	return [[self documentsDirectory] stringByAppendingPathComponent:[self storeFilename]];
}

- (NSString *)documentsDirectory {
	NSString *documentsDirectory = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

- (NSManagedObjectContext *)mainContext {
	if (_mainContext == nil) {
		_mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		_mainContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
	}
	return _mainContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	if (_managedObjectModel == nil) {
		NSURL *storeURL = [NSURL fileURLWithPath:[self pathToModel]];
		_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
	}
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];

	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	return _persistentStoreCoordinator;
}

@end
