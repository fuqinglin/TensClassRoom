//
//  QuestionModel.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/6.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (instancetype)initWithAVObject:(AVObject *)object
{
    self = [super initWithAVObject:object];
    if (self) {
        
        NSString *content = [object objectForKey:@"questionTitle"];
        CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(TSCREEN_WIDTH - 65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]} context:nil].size.height + 45;
        
        self.textHeight = contentHeight;
    }
    
    return self;
}


@end
