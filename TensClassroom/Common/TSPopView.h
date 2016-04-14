//
//  TSPopView.h
//  TensWeibo_Demo
//
//  Created by qinglinfu on 15/10/6.
//  Copyright © 2015年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PopViewIsLeft,
    PopViewIsCenter,
    PopViewIsRight
} PopViewType;

@interface TSPopView : UIView

// 内容视图
@property (nonatomic,strong)UIView *contentView;

+ (instancetype)creat;

- (void)showPopView:(UIView *)view withType:(PopViewType)type;

@end
