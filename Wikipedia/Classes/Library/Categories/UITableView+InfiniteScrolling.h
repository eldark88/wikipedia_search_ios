//
//  UITableView+ActivityIndicator.h
//  Wikipedia
//
//  Created by eldark88 on 9/2/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "TableViewInfiniteScrollingDecorator.h"

@interface UITableView (InfiniteScrolling)

- (void)addInfiniteScrollingHandler:(TableViewInfiniteScrollingHandler)handler;
- (void)setEnableInfiniteScrolling:(BOOL)enabled;
- (void)startInfiniteScrollingAnimation;
- (void)stopInfiniteScrollingAnimation;

@end
