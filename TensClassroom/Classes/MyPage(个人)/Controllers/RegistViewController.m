//
//  RegistViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/5.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTxf;
@property (weak, nonatomic) IBOutlet UITextField *emailTxf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxf;
@property (weak, nonatomic) IBOutlet UITextField *okPasswordTxf;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.userNameTxf becomeFirstResponder];
    
}

#pragma mark - buttonActions
- (IBAction)registAction:(UIButton *)sender {
    
    if (![self verifyInfos]) return;
    
    AVUser *user = [AVUser user];
    user.username = self.userNameTxf.text;
    user.password = self.okPasswordTxf.text;
    user.email = self.emailTxf.text;
    
    [self showHUD:@"注册中..."];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        [self hiddenHUD];

        if (!succeeded) {
            
            [self showTextHUD:error.localizedDescription];
            return;
            
        } else {
            
            [self showCustomHUD:@"注册成功!"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self dismissViewController];
                
            });  
        }
    }];
    
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewController];
}

- (void)dismissViewController
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 验证输入的信息
- (BOOL)verifyInfos
{
    if (_userNameTxf.text.length == 0 || _passwordTxf.text.length == 0 || _okPasswordTxf.text.length == 0 || _emailTxf.text.length == 0) {
        
        return NO;
    }
    
    if (![_passwordTxf.text isEqualToString:_okPasswordTxf.text]) {
        
        return NO;
    }
    
    return YES;
}


@end
