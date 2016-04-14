//
//  QuestionDetailCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/28.
//  Copyright © 2016年 十安科技. All rights reserved.
//



#import "QuestionDetailCell.h"
#import "QuestionModel.h"

@interface QuestionDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *questionContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation QuestionDetailCell

- (void)awakeFromNib {
    
}

- (void)setModel:(QuestionModel *)model
{
    _model = model;
    
    self.questionContentLabel.text = model.questionTitle;
    self.authorLabel.text = model.authorName;
    self.answerNumLabel.text = model.answerCount;
    self.scanNumLabel.text = model.scanCount;
    self.dateLabel.text = model.createDate;
}


@end
