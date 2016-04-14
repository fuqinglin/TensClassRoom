//
//  QuestionDetailViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/28.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
@class QuestionModel;

@interface QuestionDetailViewController : TSBaseViewController

@property (nonatomic, strong) QuestionModel *model;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) void(^changAnswerOrScanHandle)();

@end
