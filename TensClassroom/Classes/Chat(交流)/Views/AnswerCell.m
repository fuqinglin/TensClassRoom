//
//  AnswerCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/28.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "AnswerCell.h"
#import "CommentModel.h"

@interface AnswerCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *answerContentLabel;


@end

@implementation AnswerCell

- (void)awakeFromNib {
    
}

- (void)setModel:(CommentModel *)model
{
    _model = model;
    
    self.nameLable.text = model.commentUserName;
    self.dateLabel.text = model.createDate;
    self.answerContentLabel.text = model.commentContent;
    
    [self.userImageView setImageWithURL:[NSURL URLWithString:model.userImageURL]];
}


@end
