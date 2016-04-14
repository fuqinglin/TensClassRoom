//
//  LoginViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/5.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "TSAppDelegate.h"

typedef NS_ENUM(NSInteger, TSButtonType) {
    
    TSButtonTypeIsLogin = 0,
    TSButtonTypeIsRegist,
    TSButtonTypeIsQQ,
    TSButtonTypeIsWX,
    TSButtonTypeIsSina
};

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTxf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxf;

@end




@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.userNameTxf becomeFirstResponder];
}


- (IBAction)loginOrRigistButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case TSButtonTypeIsLogin:
            [self loginAction];
            break;
            
        case TSButtonTypeIsRegist:
            [self registAction];
            break;
    }
}

#pragma mark - 登录\注册事件
- (void)loginAction
{
    [self showHUD:@"登录中..."];
    [AVUser logInWithUsernameInBackground:_userNameTxf.text password:_passwordTxf.text block:^(AVUser *user, NSError *error) {
        
        [self hiddenHUD];
        if (error) {
            [self showTextHUD:error.localizedDescription];
            return;
        }
        
        [self showCustomHUD:@"登录成功!"];
        if (self.loginHandel) {
            _loginHandel();
        }
        // 登录成功后发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:kTSLoginSuccessNotification object:nil];
        
        // 打开聊天
        [(TSAppDelegate *)[UIApplication sharedApplication].delegate openClient];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismissViewController];
        });

    }];
}

- (void)registAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:nil];
    RegistViewController *registVC = [storyboard instantiateViewControllerWithIdentifier:@"RegistViewController"];
    
    [self presentViewController:registVC animated:YES completion:nil];
}


- (IBAction)otherLoginButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case TSButtonTypeIsQQ:
            
            break;
        case TSButtonTypeIsWX:
            break;
        
        case TSButtonTypeIsSina:
            
            break;
    }
    
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewController];
}

- (void)dismissViewController
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
