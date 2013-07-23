//
//  AppDelegate.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "LoginViewController.h"

@interface AppDelegate () <LoginViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	LoginViewController *loginVC = [[LoginViewController alloc] init];
	loginVC.delegate = self;
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[self.window.rootViewController presentViewController:nc animated:NO completion:nil];
    return YES;
}

#pragma mark - LoginViewControllerDelegate methods
- (void)loginViewController:(LoginViewController *)vc succesfullLoginWithToken:(NSString *)token {
	[vc dismissViewControllerAnimated:YES completion:nil];
}


@end
