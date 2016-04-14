//
//  QuestionListViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/23.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
@class QuestionModel;

@interface QuestionListViewController : TSBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy)void (^pushToDetailBlock)(QuestionModel *model, NSInteger row);

/** 加载新提交的问题 **/
- (void)loadNewQuestionData;

@end
