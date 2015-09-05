//
//  DetailViewModel.m
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "DetailViewModel.h"

@implementation DetailViewModel

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url {
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
    }
    return self;
}

- (NSURLRequest *)urlRequest {
    return [NSURLRequest requestWithURL:self.url];
}

@end
