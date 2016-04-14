//
//  QuestionListCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/24.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "QuestionListCell.h"
#import "QuestionModel.h"

@interface QuestionListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;


@end

@implementation QuestionListCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(answerCountChange:) name:kTSQuestionAnswerFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanCountChange:) name:kTSQusstionScanFinishNotification object:nil];
}

- (void)setModel:(QuestionModel *)model
{
    _model = model;
    self.titleLable.text = model.questionTitle;
    self.authorNameLabel.text = model.authorName;
    self.answerLabel.text = model.answerCount;
    self.scanLabel.text = model.scanCount;
    self.dateLabel.text = model.createDate;
    
}

#pragma mark - 通知监听方法
- (void)answerCountChange:(NSNotification *)notification
{
    NSInteger row = [notification.object[0] integerValue];
    if (row == self.row) {
        NSString *answerCount = [NSString stringWithFormat:@"%@",notification.object[1]];
        self.answerLabel.text = answerCount;
    }
}

- (void)scanCountChange:(NSNotification *)notification
{
    NSInteger row = [notification.object[0] integerValue];
    if (row == self.row) {
        NSString *scanCount = [NSString stringWithFormat:@"%@",notification.object[1]];
        self.scanLabel.text = scanCount;
    }
}


@end
