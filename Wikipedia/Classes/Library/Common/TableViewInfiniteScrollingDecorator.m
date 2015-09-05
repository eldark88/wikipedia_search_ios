//
//  TableViewInfiniteScrollingDecorator.m
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "TableViewInfiniteScrollingDecorator.h"

static CGFloat const InfiniteScrollingViewHeight = 44;

typedef NS_ENUM (NSInteger, InfiniteScrollingState) {
	InfiniteScrollingStateStopped = 0,
	InfiniteScrollingStateTriggered = 1,
	InfiniteScrollingStateLoading = 2
};

@interface TableViewInfiniteScrollingDecorator ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) InfiniteScrollingState state;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, readwrite) CGFloat originalBottomInset;

@end

@implementation TableViewInfiniteScrollingDecorator

- (instancetype)initWithTableView:(UITableView *)tableView {
	self = [super init];
	if (self) {
        self.tableView = tableView;
        self.originalBottomInset = self.tableView.contentInset.bottom;

        //-- add KVO observers
		__weak id weakSelf = self;
		[self addObserver:weakSelf forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
		[self addObserver:weakSelf forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.tableView addObserver:weakSelf forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

        self.enabled = YES;
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"contentOffset"]) {
		[self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
	}
	else if ([keyPath isEqualToString:@"state"]) {
		InfiniteScrollingState fromState = [[change valueForKey:NSKeyValueChangeOldKey] intValue];
		InfiniteScrollingState toState = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
		[self handleStateTransitionFromState:fromState toState:toState];
	}
	else if ([keyPath isEqualToString:@"enabled"]) {
		BOOL newValue = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        BOOL oldValue = [[change valueForKey:NSKeyValueChangeOldKey] boolValue];
        
        if (newValue!=oldValue) {
            [self handleEnabled:newValue];
        }
	}
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
	if(self.state != InfiniteScrollingStateLoading && self.enabled) {
		CGFloat scrollViewContentHeight = self.tableView.contentSize.height;
		CGFloat scrollOffsetThreshold = scrollViewContentHeight-self.tableView.bounds.size.height;

		if(!self.tableView.isDragging && self.state == InfiniteScrollingStateTriggered) {
			self.state = InfiniteScrollingStateLoading;
		}
		else if(contentOffset.y > scrollOffsetThreshold && self.state == InfiniteScrollingStateStopped && self.tableView.isDragging) {
			self.state = InfiniteScrollingStateTriggered;
		}
		else if(contentOffset.y < scrollOffsetThreshold  && self.state != InfiniteScrollingStateStopped) {
			self.state = InfiniteScrollingStateStopped;
		}
	}
}

- (void)handleStateTransitionFromState:(InfiniteScrollingState)fromState toState:(InfiniteScrollingState)toState {
	switch (toState) {
        case InfiniteScrollingStateStopped:
            [self.activityIndicatorView stopAnimating];
            break;

        case InfiniteScrollingStateTriggered:
            [self.activityIndicatorView startAnimating];
            break;

        case InfiniteScrollingStateLoading:
            [self.activityIndicatorView startAnimating];
            break;
	}

	if(fromState == InfiniteScrollingStateTriggered && toState == InfiniteScrollingStateLoading && self.handler && self.enabled) {
		self.handler();
	}
}

- (void)handleEnabled:(BOOL)enabled {
	if (enabled) {
		[self setupActivityIndicatorViewIfNeeded];

		[self setTableViewContentInsetForInfiniteScrolling];
	}
	else {
		[self resetTableViewContentInset];

        [self stopAnimating];
	}
}

- (void)setupActivityIndicatorViewIfNeeded {
	if (!self.activityIndicatorView) {
		[self setupActivityIndicatorView];
	}
}

- (void)setupActivityIndicatorView {
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;

	if (!self.tableView.backgroundView) {
		self.tableView.backgroundView = [UIView new];
	}

	[self.tableView.backgroundView addSubview:self.activityIndicatorView];

	[self.tableView.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView.backgroundView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.activityIndicatorView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:10.0f]];
	[self.tableView.backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView.backgroundView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
}

#pragma mark -
- (void)startAnimating {
	self.state = InfiniteScrollingStateLoading;
}

- (void)stopAnimating {
	self.state = InfiniteScrollingStateStopped;
}

#pragma mark - UITableView Content Insets Methods
- (void)resetTableViewContentInset {
    UIEdgeInsets currentInsets = self.tableView.contentInset;
    currentInsets.bottom = self.originalBottomInset;
	[self setTableViewContentInset:currentInsets];
}

- (void)setTableViewContentInsetForInfiniteScrolling {
	UIEdgeInsets currentInsets = self.tableView.contentInset;
    currentInsets.bottom = self.originalBottomInset + InfiniteScrollingViewHeight;
	[self setTableViewContentInset:currentInsets];
}

- (void)setTableViewContentInset:(UIEdgeInsets)contentInset {
	[UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.tableView.contentInset = contentInset;
                     }
                     completion:NULL];
}

@end
