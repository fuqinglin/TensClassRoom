//
//  QuestionModel.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/6.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseModel.h"

@interface QuestionModel : TSBaseModel

@property (copy, nonatomic) NSString *questionTitle;
@property (copy, nonatomic) NSString *authorName;
@property (copy, nonatomic) NSString *answerCount;
@property (copy, nonatomic) NSString *scanCount;

@property (assign, nonatomic)CGFloat textHeight;

@end
