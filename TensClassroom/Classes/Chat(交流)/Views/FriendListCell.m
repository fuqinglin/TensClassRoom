//
//  FriendListCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/23.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "FriendListCell.h"
#import "FriendModel.h"

@interface FriendListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;

@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation FriendListCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setModel:(FriendModel *)model
{
    _model = model;
    
    self.friendNameLabel.text = model.username;
    [self.friendImageView setImageWithURL:[NSURL URLWithString:model.userImageURL]];
}


@end
