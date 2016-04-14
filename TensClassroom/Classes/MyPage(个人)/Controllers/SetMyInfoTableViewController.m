//
//  SetMyInfoTableViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/6.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "SetMyInfoTableViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "TSAlertView.h"

@interface SetMyInfoTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic)MBProgressHUD *HUD;

@end

@implementation SetMyInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView.bounds = CGRectMake(0, 0, 0, 70);
    [self showUserImage];
}

- (IBAction)logOutButtonAction:(UIButton *)sender {
    
    [TSAlertView showMessage:@"确定退出登录？" handler:^{
        [AVUser logOut];
        if (self.modifyFinishHandle) {
            
            _modifyFinishHandle();
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

#pragma mark - 显示/修改头像

- (void)showUserImage
{
    AVFile *imageFile = [[AVUser currentUser] objectForKey:@"userImage"];
    [imageFile getThumbnail:YES width:80 height:80 withBlock:^(UIImage *image, NSError *error) {
        if(!image) return;
        self.userImageView.image = image;
    }];
}

- (void)modifyUserImage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    
    [self showHUD:@"设置中..."];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        NSData *imageData = UIImageJPEGRepresentation(originalImage, 0.1);
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[AVUser currentUser].username];
        AVFile *imageFile = [AVFile fileWithName:fileName data:imageData];
    
        [[AVUser currentUser] setObject:imageFile forKey:@"userImage"];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           
            if (succeeded) {
                
                [[AVUser currentUser] saveInBackground];
                
                [self hiddenHUD];
                [self showCustomHUD:@"修改成功！"];
                if (self.modifyFinishHandle) {
                    
                    _modifyFinishHandle();
                }
            }
            
        }];
    }];
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        self.userImageView.image = originalImage;
        
    }];
    
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            [self modifyUserImage];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - HUD提示框

- (void)showHUD:(NSString *)title
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    _HUD.labelText = title;
    _HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:_HUD];
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
    _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    _HUD.labelText = title;
    [keyWindow addSubview:_HUD];
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:2];
    
}

@end
