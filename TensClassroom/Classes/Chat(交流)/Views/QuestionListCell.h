//
//  QuestionListCell.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/24.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;

@interface QuestionListCell : UITableViewCell

@property (copy, nonatomic) NSDictionary *questionDic;
@property (strong, nonatomic) QuestionModel *model;
@property (assign, nonatomic) NSInteger row;


@end
