//
//  LoginViewController.m
//  InstaClient
//
//  Created by Vitaly on 23.07.13.
//  Copyright (c) 2013 Vitaly. All rights reserved.
//

#import "LoginViewController.h"
#import "InstagramClient.h"
#import "Feed.h"

@interface LoginViewController () <UIWebViewDelegate>
@property(nonatomic, weak) UIWebView *webView;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Аутентификация";
	UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:webView];
	webView.delegate = self;
	self.webView = webView;
	
	NSURL *URL = [InstagramClient urlForAuthentication];
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	[self.webView loadRequest:request];
	
//	UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Закрыть" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
//	self.navigationItem.leftBarButtonItem = closeButton;
}

- (void)close:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getCodeFromURL:(NSURL *)URL {
	NSString *query = URL.query;
	if (query) {
		NSArray *components = [query componentsSeparatedByString:@"&"];
		for (NSString *str in components) {
			NSArray *array = [str componentsSeparatedByString:@"="];
			if ([array[0] isEqualToString:@"code"]) {
				return array[1];
			}
		}
	}
	return nil;
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"%@", [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
	if ([request.URL.scheme isEqualToString:[InstagramClient redirectScheme]]) {
		NSString *code = [self getCodeFromURL:request.URL];
		NSLog(@"code = %@", code);
		
		[InstagramClient sharedClient].code = code;
		[[InstagramClient sharedClient] getTokenWithBlock:^(NSString *token, NSError *error) {
			if (error) {
				NSLog(@"Fail %@", error);
			} else {
				NSLog(@"Token = %@", token);
				if ([self.delegate respondsToSelector:@selector(loginViewController:succesfullLoginWithToken:)]) {
					[self.delegate loginViewController:self succesfullLoginWithToken:token];
				}
				[self dismissViewControllerAnimated:YES completion:nil];
				[[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)NotificationUserIsSignedIn object:self];
			}
		}];
		return NO;
	}
	return YES;
}
@end
