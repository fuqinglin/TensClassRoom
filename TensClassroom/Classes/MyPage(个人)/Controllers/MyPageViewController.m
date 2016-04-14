//
//  MyPageViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/5.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "MyPageViewController.h"
#import "LoginViewController.h"
#import "SetMyInfoTableViewController.h"
#import "TSButton.h"

@interface MyPageViewController ()

@property (nonatomic, strong) UIStoryboard *myStoryboard;
@property (weak, nonatomic) IBOutlet TSButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myStoryboard = [UIStoryboard storyboardWithName:@"MyPage" bundle:nil];
    [self showUserInfos];

}

#pragma mark - 显示用户头像、用户名
- (void)showUserInfos
{
    self.loginButton.layer.cornerRadius = 50;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.borderWidth = 3;
    if ([AVUser currentUser] == nil) {
        
        self.userNameLabel.text = @"点击头像登录";
        [self.loginButton setBackgroundImage:[UIImage imageNamed:@"header.jpg"] forState:UIControlStateNormal];
        return;
    }
    
    AVFile *imageFile = [[AVUser currentUser] objectForKey:@"userImage"];
    self.userNameLabel.text = [AVUser currentUser].username;
    [imageFile getThumbnail:YES width:200 height:200 withBlock:^(UIImage *image, NSError *error) {
        if (!image) return;
        [self.loginButton setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

#pragma mark - ButtonAction
- (IBAction)showLoginPageAction:(UIButton *)sender {
    
    if ([AVUser currentUser] == nil) {
        
        LoginViewController *loginVC = [self.myStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [loginVC setLoginHandel:^{
            
            [self showUserInfos];
        }];
        [self presentViewController:loginVC animated:YES completion:NULL];
        
    } else {
        
        SetMyInfoTableViewController *setMyInfoVC = [self.myStoryboard instantiateViewControllerWithIdentifier:@"SetMyInfoTableViewController"];
        [setMyInfoVC setModifyFinishHandle:^{
           
            [self showUserInfos];
        }];
        
        [self.navigationController pushViewController:setMyInfoVC animated:YES];
    }
    
}


#pragma mark - Table view data source


@end
