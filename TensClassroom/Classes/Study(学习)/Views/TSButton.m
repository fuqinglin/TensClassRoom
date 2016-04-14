//
//  TSButton.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/23.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSButton.h"

@implementation TSButton

- (void)awakeFromNib
{
    self.layer.cornerRadius = 3;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:0 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.alpha = 0.8;
        
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

@end
