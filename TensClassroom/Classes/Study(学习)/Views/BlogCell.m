//
//  BlogCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "BlogCell.h"
#import "BlogModel.h"

@interface BlogCell ()
@property (weak, nonatomic) IBOutlet UIImageView *blogImageView;
@property (weak, nonatomic) IBOutlet UILabel *blogTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogDateLabel;


@end

@implementation BlogCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(BlogModel *)model
{
    _model = model;
    
    _blogTitleLabel.text = model.blogTitle;
    _blogDateLabel.text = model.createDate;
    [_blogImageView setImageWithURL:[NSURL URLWithString:model.blogImageURL]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
