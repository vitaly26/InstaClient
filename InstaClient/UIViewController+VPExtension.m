//
//  UIViewController+VPExtension.m
//  InstaClient
//
//  Created by Vitaly on 26.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "UIViewController+VPExtension.h"

@implementation UIViewController (VPExtension)

+ (UIViewController *)vp_topMostController {
	UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
	while (topController.presentedViewController) {
		topController = topController.presentedViewController;
	}
    return topController;
}

@end
