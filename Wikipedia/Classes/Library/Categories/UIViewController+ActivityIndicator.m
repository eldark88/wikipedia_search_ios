//
//  UIViewController+ActivityIndicator.m
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "UIViewController+ActivityIndicator.h"
#import <objc/runtime.h>

static const void *UIViewControllerActivityIndicatorContainerViewKey = &UIViewControllerActivityIndicatorContainerViewKey;
static const void *UIViewControllerActivityIndicatorViewKey = &UIViewControllerActivityIndicatorViewKey;

@implementation UIViewController (ActivityIndicator)

- (void)showActivityIndicatorView {
	UIView *containerView = [self activityIndicatorContainerView];
	if (containerView) {
		return;
	}

	//-- setup container view
	containerView = [UIView new];
	containerView.translatesAutoresizingMaskIntoConstraints = NO;
	containerView.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];

	[self.view addSubview:containerView];

    //-- setup UIActivityIndicatorView
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
	activityIndicator.color = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1.0f];
	[containerView addSubview:activityIndicator];

	//-- containerView contstraints
	[self.view addConstraints:[NSLayoutConstraint
	                           constraintsWithVisualFormat:@"H:|-0-[containerView]-0-|"
	                           options:NSLayoutFormatDirectionLeadingToTrailing
	                           metrics:nil
	                           views:NSDictionaryOfVariableBindings(containerView)]];
	[self.view addConstraints:[NSLayoutConstraint
	                           constraintsWithVisualFormat:@"V:|-0-[containerView]-0-|"
	                           options:NSLayoutFormatDirectionLeadingToTrailing
	                           metrics:nil
	                           views:NSDictionaryOfVariableBindings(containerView)]];

	//-- activityIndicator contstraints
	[containerView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator
	                              attribute:NSLayoutAttributeCenterX
	                              relatedBy:NSLayoutRelationEqual
	                              toItem:containerView
	                              attribute:NSLayoutAttributeCenterX
	                              multiplier:1.f constant:0.f]];

	[containerView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator
	                              attribute:NSLayoutAttributeCenterY
	                              relatedBy:NSLayoutRelationEqual
	                              toItem:containerView
	                              attribute:NSLayoutAttributeCenterY
	                              multiplier:1.f constant:0.f]];

	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];

	[self setActivityIndicatorContainerView:containerView];
	[self setActivityIndicatorView:activityIndicator];

	[activityIndicator startAnimating];
}

- (void)dismissActivityIndicatorView {
	UIView *containerView = [self activityIndicatorContainerView];
	UIActivityIndicatorView *loadingIndicatorView = [self activityIndicatorView];

    [loadingIndicatorView stopAnimating];

    [UIView animateWithDuration:0.2f animations:^{
        containerView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [containerView removeFromSuperview];

        [self setActivityIndicatorContainerView:nil];
        [self setActivityIndicatorView:nil];
    }];
}

#pragma mark -
- (void)setActivityIndicatorContainerView:(UIView *)containerView {
	objc_setAssociatedObject(self, UIViewControllerActivityIndicatorContainerViewKey, containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)activityIndicatorContainerView {
	return objc_getAssociatedObject(self, UIViewControllerActivityIndicatorContainerViewKey);
}

- (void)setActivityIndicatorView:(UIActivityIndicatorView *)activityIndicatorView {
	objc_setAssociatedObject(self, UIViewControllerActivityIndicatorViewKey, activityIndicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)activityIndicatorView {
	return objc_getAssociatedObject(self, UIViewControllerActivityIndicatorViewKey);
}

#pragma mark -

@end
