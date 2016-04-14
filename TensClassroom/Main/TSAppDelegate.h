//
//  AppDelegate.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/22.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AVIMClient *client;

/* 打开聊天服务*/
- (void)openClient;
@end

