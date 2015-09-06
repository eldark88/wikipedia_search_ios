//
//  SessionTaskOperation.h
//  Wikipedia
//
//  Created by eldark88 on 8/29/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "AsyncOperation.h"

@protocol FetchSearchOperation;

@interface FetchSearchOperation : AsyncOperation

@property (nonatomic, strong, readonly) NSURLSessionTask *task;
@property (nonatomic, strong, readonly) id object;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, assign) id<FetchSearchOperation> delegate;
@property (nonatomic, strong) NSString * keyword;
@property (nonatomic, strong) NSNumber * offset;

@end


@protocol FetchSearchOperation <NSObject>

- (void)didReceiveObject:(id)object;
- (void)didFailWithError:(NSError *)error;

@end