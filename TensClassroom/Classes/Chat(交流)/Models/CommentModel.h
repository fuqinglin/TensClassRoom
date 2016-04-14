//
//  CommentModel.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/6.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseModel.h"

@interface CommentModel : TSBaseModel

@property (copy, nonatomic) NSString *commentContent;
@property (copy, nonatomic) NSString *commentUserName;
@property (strong, nonatomic) NSString *userImageURL;
@property (assign, nonatomic) CGFloat commentTextHeight;

@end
