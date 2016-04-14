
//
//  FriendModel.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/11.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

- (instancetype)initWithAVObject:(AVObject *)object
{
    self = [super initWithAVObject:object];
    if (self) {
        
        AVFile *imageFile = [object objectForKey:@"userImage"];
        self.userImageURL = imageFile.url;
    }
    
    return self;
}

@end
