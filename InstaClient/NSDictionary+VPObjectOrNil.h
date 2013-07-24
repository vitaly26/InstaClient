//
//  NSDictionary+VPObjectOrNil.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (VPObjectOrNil)
- (id)vp_objectOrNilForKey:(id)key;
- (id)vp_valueOrNilForKeyPath:(NSString *)keyPath;
@end
