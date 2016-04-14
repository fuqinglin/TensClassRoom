//
//  AddListView.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/11.
//  Copyright © 2016年 十安科技. All rights reserved.
//


#import "AddListView.h"

static NSString *const cellID = @"newCell";

@interface AddListView ()
{
    NSArray *_itemsTitle;
    NSArray *_itemsImage;
}

@end

@implementation AddListView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _itemsTitle = @[@"发起群聊",@"添加好友"];
        _itemsImage = @[@"tabbar_message",@"tabbar_my"];
        
        [self addListItems];
    }
    
    return self;
}

- (void)addListItems
{
    for (int i = 0; i<_itemsTitle.count; i++) {
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        itemButton.frame = CGRectMake(0, i * 45, self.bounds.size.width, 50);
        [itemButton setTitle:_itemsTitle[i] forState:UIControlStateNormal];
        [itemButton setImage:[UIImage imageNamed:_itemsImage[i]] forState:UIControlStateNormal];
        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        itemButton.tag = i;
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemButton setTintColor:[UIColor whiteColor]];
        [itemButton addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:itemButton];
    }
}

- (void)itemButtonAction:(UIButton *)button
{
    if (self.addButtonHandle) {
        
        _addButtonHandle(button.tag);
    }
}


@end
