//
//  VideoModel_.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (instancetype)initWithAVObject:(AVObject *)object
{
    if (self = [super initWithAVObject:object]) {
        
        self.videoImage = [object objectForKey:@"videoImage"];
    }
    
    return self;
}


@end
