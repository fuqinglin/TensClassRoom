//
//  LeftViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/22.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "LeftViewController.h"
#import <UIViewController+MMDrawerController.h>

@interface LeftViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
    }];
}


@end
