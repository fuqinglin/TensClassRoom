//
//  AddFriendCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/11.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "AddFriendCell.h"
#import "FriendModel.h"

@interface AddFriendCell ()
@property (weak, nonatomic) IBOutlet UIImageView *friendImage;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *markButton;

@end

@implementation AddFriendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(FriendModel *)model
{
    _model = model;
    
    self.friendNameLabel.text = model.username;
    
    [self.friendImage setImageWithURL:[NSURL URLWithString:model.userImageURL]];
    self.markButton.hidden = model.isFriend;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
