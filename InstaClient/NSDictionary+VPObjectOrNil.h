//
//  NSDictionary+VPObjectOrNil.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (VPObjectOrNil)
- (id)objectOrNilForKey:(id)key;
- (id)valueOrNilForKeyPath:(NSString *)keyPath;
@end
