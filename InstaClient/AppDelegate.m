//
//  AppDelegate.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "AppDelegate.h"

#import "FeedsViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"

@interface AppDelegate () <LoginViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[NSURLCache sharedURLCache] setDiskCapacity:150*1024*1024];
	[[NSURLCache sharedURLCache] setMemoryCapacity:50*1024*1024];
	
	[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	FeedsViewController *feedsVC = [FeedsViewController new];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:feedsVC];
	self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
	
	LoginViewController *loginVC = [[LoginViewController alloc] init];
	loginVC.delegate = self;
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[self.window.rootViewController presentViewController:nc animated:NO completion:nil];
    return YES;
}

#pragma mark - LoginViewControllerDelegate methods
- (void)loginViewController:(LoginViewController *)vc succesfullLoginWithToken:(NSString *)token {
//	[vc dismissViewControllerAnimated:YES completion:nil];
}


@end
