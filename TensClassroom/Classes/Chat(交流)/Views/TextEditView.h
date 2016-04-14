//
//  TextEditView.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/28.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEditView : UIView <UITextViewDelegate>

@property (nonatomic, copy)void(^sendTextHandle)(NSString *text);

+ (instancetype)defaultEditeView;

- (void)show;

@end
