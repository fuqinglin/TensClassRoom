//
//  TSAlertView.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertHandler)();

@interface TSAlertView : UIView

+ (void)showMessage:(NSString *)message handler:(AlertHandler)handler;

@end
