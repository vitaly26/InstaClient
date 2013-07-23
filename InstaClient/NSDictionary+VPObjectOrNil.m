//
//  NSDictionary+VPObjectOrNil.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "NSDictionary+VPObjectOrNil.h"

@implementation NSDictionary (VPObjectOrNil)

- (id)objectOrNilForKey:(id)key {
	id obj = [self objectForKey:key];
	if((NSNull *)obj == [NSNull null]) {
		return nil;
	}
	return obj;
}

- (id)valueOrNilForKeyPath:(NSString *)keyPath {
	id obj = [self valueForKeyPath:keyPath];
	if((NSNull *)obj == [NSNull null]) {
		return nil;
	}
	return obj;
}

@end
