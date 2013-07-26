//
//  LoginManager.m
//  InstaClient
//
//  Created by Vitaly on 26.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "LoginManager.h"
#import "LoginViewController.h"
#import "InstagramClient.h"
#import "UIViewController+VPExtension.h"

@interface LoginManager () <LoginViewControllerDelegate>

@end

@implementation LoginManager

#pragma mark - Public Methods

+ (LoginManager *)sharedLoginManager {
	static LoginManager *_shared = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_shared = [[LoginManager alloc] init];
	});
	return _shared;
}

- (void)signInAnimated:(BOOL)animated {
	[self showLoginViewController:animated];
}

- (void)signOutAnimated:(BOOL)animated {
	[self deleteCookies];
	[self showLoginViewController:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserIsSignedOut object:self];
}

#pragma mark - Private Methods
- (void)deleteCookies {
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
	for(NSHTTPCookie *cookie in cookies) {
		[[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
	}
}

- (void)showLoginViewController:(BOOL)animated {
	LoginViewController *loginViewController = [LoginViewController new];
	loginViewController.delegate = self;
//	loginViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	UIViewController *vc = [UIViewController vp_topMostController];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginViewController];
	[vc presentViewController:nc animated:animated completion:nil];
}

#pragma mark - LoginViewControllerDelegate Methods
- (void)loginViewController:(LoginViewController *)vc succesfullLoginWithToken:(NSString *)token {
	[vc dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserIsSignedIn object:self];
}

@end
