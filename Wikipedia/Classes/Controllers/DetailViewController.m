//
//  DetailViewController.m
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailViewModel.h"
#import "UIViewController+ActivityIndicator.h"

@implementation DetailViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = self.viewModel.title;

	self.webView.delegate = self;

	[self.webView loadRequest:self.viewModel.urlRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	//-- stop loading
	[self.webView stopLoading];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self showActivityIndicatorView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self dismissActivityIndicatorView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

@end
