//
//  CommentModel.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/6.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)initWithAVObject:(AVObject *)object
{
    self = [super initWithAVObject:object];
    if (self) {
        
        self.commentUserName = [object objectForKey:@"commentUserName"];
        
        AVFile *imageFile = [object objectForKey:@"userImage"];
        self.userImageURL = imageFile.url;
        
        NSString *content = [object objectForKey:@"commentContent"];
        CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(TSCREEN_WIDTH - 70, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]} context:nil].size.height + 45;
        self.commentTextHeight = contentHeight;
    }
    
    return self;
}

@end
