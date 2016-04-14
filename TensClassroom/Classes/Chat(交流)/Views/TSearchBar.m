//
//  TSearchBar.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/23.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSearchBar.h"

@implementation TSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextField];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setTextField];
}

- (void)setTextField
{
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftView = [[UIImageView alloc] init];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    leftView.bounds = CGRectMake(0, 0, 25, 15);
    leftView.image = [UIImage imageNamed:@"搜索_灰色"];
    self.leftView = leftView;
    self.returnKeyType = UIReturnKeySearch;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tintColor = [UIColor lightGrayColor];
    self.placeholder = @"搜索";
    self.font = [UIFont systemFontOfSize:14];
}


@end
