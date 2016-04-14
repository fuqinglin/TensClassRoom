//
//  TSMMDrawerController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/22.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSMMDrawerController.h"
#import "LeftViewController.h"
#import "TSTabBarViewController.h"


@interface TSMMDrawerController ()

@end

@implementation TSMMDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMMDrawer];
}

#pragma mark - 设置抽屉布局
- (void)setMMDrawer
{
    LeftViewController *leftVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    TSTabBarViewController *tabBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TSTabBarViewController"];
    
    self.leftDrawerViewController = leftVC;
    self.centerViewController = tabBarVC;
    self.maximumLeftDrawerWidth = TSCREEN_WIDTH - 100;
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    
}




@end
