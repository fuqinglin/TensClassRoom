//
//  TSBaseViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/22.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>

@interface TSBaseViewController : UIViewController

- (void)showTextHUD:(NSString *)title;

- (void)showHUD:(NSString *)title;

- (void)showCustomHUD:(NSString *)title;

- (void)hiddenHUD;

@end
