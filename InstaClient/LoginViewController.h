//
//  LoginViewController.h
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController
@property(nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end

@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginViewController:(LoginViewController *)vc succesfullLoginWithToken:(NSString *)token;

@end
