//
//  SetMyInfoTableViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/6.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetMyInfoTableViewController : UITableViewController

@property (copy,nonatomic) void(^modifyFinishHandle)();

@end
