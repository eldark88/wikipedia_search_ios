//
//  SessionTaskOperation.m
//  Wikipedia
//
//  Created by eldark88 on 8/29/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "FetchSearchOperation.h"
#import "AsyncOperation+Private.h"

static NSString * const apiURL = @"https://en.wikipedia.org/w/api.php";
static NSString * const apiLimit = @"50";

@interface FetchSearchOperation ()

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSError *error;

@end

@implementation FetchSearchOperation

- (NSURLRequest *)buildURLRequest {
    NSURLComponents *components = [NSURLComponents componentsWithString:apiURL];
    NSURLQueryItem *action = [NSURLQueryItem queryItemWithName:@"action" value:@"query"];
    NSURLQueryItem *list = [NSURLQueryItem queryItemWithName:@"list" value:@"search"];
    NSURLQueryItem *format = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *limit = [NSURLQueryItem queryItemWithName:@"srlimit" value:apiLimit];
    NSURLQueryItem *search = [NSURLQueryItem queryItemWithName:@"srsearch" value:self.keyword];
    NSURLQueryItem *offset = [NSURLQueryItem queryItemWithName:@"sroffset" value:self.offset.stringValue];
    components.queryItems = @[action, list, format, limit, search, offset];
    
    return [NSURLRequest requestWithURL:components.URL];
}

- (void)main {
    //-- add KVO for isCancelled and make sure that we are not making a strong reference to self
    __weak id weakSelf = self;
    [self addObserver:weakSelf forKeyPath:@"isCancelled" options:NSKeyValueObservingOptionNew context:nil];
    
    //-- make network request
    NSURLRequest *request = [self buildURLRequest];
    
    //-- run network task
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.timeoutIntervalForRequest = 10.0;
    sessionConfig.timeoutIntervalForResource = 10.0;
    
    self.task = [[NSURLSession sessionWithConfiguration:sessionConfig] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //-- save error
        self.error = error;
        
        //--- error callback
        if (error && self.delegate) {
            [self.delegate didFailWithError:error];
        }
        else {
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //-- save object
            self.object = object;
            
            //-- success callback
            if (self.delegate) {
                [self.delegate didReceiveObject:object];
            }
        }
        
        //-- update flags
        self.executing = NO;
        self.finished = YES;
    }];
    
    //-- start network task
    [self.task resume];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isCancelled"] && [[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
        //-- cancel network task
        [self.task cancel];
        
        //-- update flags
        self.executing = NO;
        self.finished = YES;
    }
}

@end
