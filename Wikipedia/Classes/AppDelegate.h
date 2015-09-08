//
//  AppDelegate.h
//  Wikipedia
//
//  Created by eldark88 on 8/29/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersistenceController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) PersistenceController *persistenceController;

@end

