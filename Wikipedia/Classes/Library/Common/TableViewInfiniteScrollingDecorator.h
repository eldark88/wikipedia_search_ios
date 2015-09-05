//
//  TableViewInfiniteScrollingDecorator.h
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TableViewInfiniteScrollingHandler)();

@interface TableViewInfiniteScrollingDecorator : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, copy) TableViewInfiniteScrollingHandler handler;
@property (nonatomic) BOOL enabled;

- (void)startAnimating;
- (void)stopAnimating;

@end
