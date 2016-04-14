//
//  AddListView.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/11.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AddButtonType) {
    
    AddButtonTypeGroup,
    AddButtonTypeAddFriend
};

@interface AddListView : UIView

@property (nonatomic, copy)void (^addButtonHandle)(AddButtonType itemType);

@end
