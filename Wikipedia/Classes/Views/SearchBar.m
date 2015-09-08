//
//  SearchBar.m
//  Wikipedia
//
//  Created by eldark88 on 9/1/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "SearchBar.h"

static NSString * const positionAnimaitonKey = @"positionAnimaiton";

@implementation SearchBar {
    CAGradientLayer *animationLayer;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    animationLayer.frame = CGRectMake(0.0f, self.frame.size.height-3.0f, self.frame.size.width, 2.0f);
    
    [self resetActivityIndicator];
}

# pragma mark - Initialization

- (void)initialize {
    UIColor *blueColor = [UIColor colorWithRed:29.0f/255.0f green:98.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    UIColor *gradientStartColor = blueColor;
    UIColor *gradientEndColor = [blueColor colorWithAlphaComponent:0.3f];
    
    animationLayer = [CAGradientLayer layer];
    animationLayer.startPoint = CGPointMake(0, 0);
    animationLayer.endPoint = CGPointMake(self.frame.size.width, 0);
    animationLayer.colors = [NSArray arrayWithObjects:(id)[gradientStartColor CGColor], (id)[gradientEndColor CGColor], nil];
    animationLayer.hidden = YES;
    animationLayer.frame = CGRectMake(0.0f, self.frame.size.height-3.0f, self.frame.size.width, 2.0f);
    
    [self.layer addSublayer:animationLayer];
}

- (CAAnimation *)mediumProgressAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(-self.frame.size.width);
    animation.toValue = @(self.frame.size.width * 2);
    animation.duration = 0.8f;
    animation.fillMode = kCAFillModeBoth;
    animation.repeatCount = INFINITY;
    
    return animation;
}

- (void)showActivityIndicator {
    if (!animationLayer.hidden) {
        return;
    }
    
    animationLayer.hidden = NO;
    [animationLayer removeAnimationForKey:positionAnimaitonKey];
    [animationLayer addAnimation:[self mediumProgressAnimation] forKey:positionAnimaitonKey];
}

- (void)dismissAcitivityIndicator {
    if (animationLayer.hidden) {
        return;
    }
    
    animationLayer.hidden = YES;
    [animationLayer removeAnimationForKey:positionAnimaitonKey];
}

- (void)resetActivityIndicator {
    if (animationLayer.animationKeys && [animationLayer.animationKeys indexOfObject:positionAnimaitonKey]!=NSNotFound) {
        [self dismissAcitivityIndicator];
        [self showActivityIndicator];
    }
}

@end