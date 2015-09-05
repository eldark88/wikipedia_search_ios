//
//  DetailViewController.h
//  Wikipedia
//
//  Created by eldark88 on 9/3/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewModel;

@interface DetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) DetailViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
