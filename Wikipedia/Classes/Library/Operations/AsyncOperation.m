//
//  AsyncOperation.m
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "AsyncOperation.h"

@implementation AsyncOperation {
    BOOL _executing;
    BOOL _finished;
}

- (void)start {
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    
    self.executing = YES;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isFinished {
    return _finished;
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting {
    return _executing;
}

@end
