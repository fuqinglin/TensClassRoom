//
//  TSAlertView.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSAlertView.h"
#import "TSMMDrawerController.h"

@implementation TSAlertView

+ (void)showMessage:(NSString *)message handler:(AlertHandler)handler
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        if (handler) {
            
            handler();
        }
        
        [alertController dismissViewControllerAnimated:NO completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
        [alertController dismissViewControllerAnimated:NO completion:nil];
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [rootViewController presentViewController:alertController animated:NO completion:nil];
}

@end
