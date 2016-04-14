//
//  DrawDownLoadView.m
//  DownLoadProgressView
//
//  Created by qinglinfu on 16/2/26.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "DownLoadProgressView.h"

@implementation DownLoadProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [self drawBgView];
    [self drawProgressView];
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    // 重绘
    [self setNeedsDisplay];
}

// 画背景
- (void)drawBgView
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radiue = self.bounds.size.width / 2 - 10;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radiue startAngle:0 endAngle:2 * M_PI clockwise:YES];
    path.lineWidth = 1;
    [BASE_COLOR setStroke];
    
    [path stroke];
}

// 画进度条
- (void)drawProgressView
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    float radius = self.bounds.size.width / 2 - 11;
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    CGFloat endAngle = _progress * 2 * M_PI - M_PI_2;
    [path addArcWithCenter:center radius:radius startAngle:-M_PI_2 endAngle: endAngle clockwise:YES];
    [BASE_COLOR setStroke];
    path.lineWidth = 3;
    path.lineCapStyle = kCGLineCapRound;
    
    [path stroke];
}


@end
