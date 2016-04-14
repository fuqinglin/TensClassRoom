//
//  TSBaseViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/22.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface TSBaseViewController ()

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation TSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)showTextHUD:(NSString *)title
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = title;
    _HUD.mode = MBProgressHUDModeText;
    _HUD.removeFromSuperViewOnHide = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_HUD];

    });
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:2.0];
}

- (void)showHUD:(NSString *)title
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = title;
    _HUD.removeFromSuperViewOnHide = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_HUD];
    });
    [_HUD show:YES];
}

- (void)hiddenHUD
{
    [_HUD hide:YES];
}

- (void)showCustomHUD:(NSString *)title
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    _HUD = [[MBProgressHUD alloc] initWithWindow:keyWindow];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.animationType = MBProgressHUDAnimationZoomIn;
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    _HUD.labelText = title;
    dispatch_async(dispatch_get_main_queue(), ^{
        [keyWindow addSubview:_HUD];
    });
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:1.5];
    
}

@end
