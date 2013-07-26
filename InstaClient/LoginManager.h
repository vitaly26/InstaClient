//
//  LoginManager.h
//  InstaClient
//
//  Created by Vitaly on 26.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (LoginManager *)sharedLoginManager;
- (void)signInAnimated:(BOOL)animated;
- (void)signOutAnimated:(BOOL)animated;

@end
