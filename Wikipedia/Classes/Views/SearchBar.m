//
//  SearchBar.m
//  Wikipedia
//
//  Created by eldark88 on 9/1/15.
//  Copyright (c) 2015 eldark88. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar {
    CAGradientLayer *animationLayer;
    CABasicAnimation *animation;
    BOOL animating;
    BOOL keepAnimating;
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
    
    [self.layer addSublayer:animationLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    animationLayer.frame = CGRectMake(0.0f, self.frame.size.height-3.0f, self.frame.size.width, 2.0f);
}

- (CAAnimation *)mediumProgressAnimation {
    animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(-self.frame.size.width);
    animation.toValue = @(self.frame.size.width * 2);
    animation.duration = 0.8f;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    //animation.repeatCount = INFINITY;
    animation.delegate = self;
    return animation;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    if (flag) {
        animating = NO;
    }
    
    if (keepAnimating && flag) {
        [animationLayer addAnimation:[self mediumProgressAnimation] forKey:@"position"];
        animating = YES;
    }
    else if (flag) {
        animationLayer.hidden = YES;
        [animationLayer removeAllAnimations];
    }
}

- (void)showActivityIndicator {
    if (keepAnimating || animating) {
        return;
    }
    
    keepAnimating = YES;
    
    animationLayer.hidden = NO;
    
    [animationLayer removeAnimationForKey:@"position"];
    
    [animationLayer addAnimation:[self mediumProgressAnimation] forKey:@"position"];
    
    animating = YES;
}

- (void)dismissAcitivityIndicator {
    keepAnimating = NO;
}

@end