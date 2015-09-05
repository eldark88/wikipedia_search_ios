//
//  UITableView+ActivityIndicator.m
//  Wikipedia
//
//  Created by eldark88 on 9/2/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "UITableView+InfiniteScrolling.h"
#import <objc/runtime.h>

static const void *UITableViewInfiniteScrollingKey = &UITableViewInfiniteScrollingKey;

@implementation UITableView (InfiniteScrolling)

- (void)addInfiniteScrollingHandler:(TableViewInfiniteScrollingHandler)handler {
	self.infiniteScrollingDecorator.handler = handler;
}

- (void)setEnableInfiniteScrolling:(BOOL)enabled {
	self.infiniteScrollingDecorator.enabled = enabled;
}

- (void)startInfiniteScrollingAnimation {
	[self.infiniteScrollingDecorator startAnimating];
}

- (void)stopInfiniteScrollingAnimation {
	[self.infiniteScrollingDecorator stopAnimating];
}

#pragma mark -
- (void)setInfiniteScrollingDecorator:(TableViewInfiniteScrollingDecorator *)infiniteScrollingDecorator {
	objc_setAssociatedObject(self, UITableViewInfiniteScrollingKey, infiniteScrollingDecorator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TableViewInfiniteScrollingDecorator *)infiniteScrollingDecorator {
	TableViewInfiniteScrollingDecorator *infiniteScrollingDecorator = objc_getAssociatedObject(self, UITableViewInfiniteScrollingKey);
	if (!infiniteScrollingDecorator) {
		infiniteScrollingDecorator = [[TableViewInfiniteScrollingDecorator alloc] initWithTableView:self];
		self.infiniteScrollingDecorator = infiniteScrollingDecorator;
	}
	return infiniteScrollingDecorator;
}

@end
