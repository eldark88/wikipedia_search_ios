//
//  DetailViewModel.h
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewModel : NSObject

- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

- (NSURLRequest *)urlRequest;

@end
