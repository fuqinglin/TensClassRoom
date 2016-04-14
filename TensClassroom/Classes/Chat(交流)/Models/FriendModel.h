//
//  FriendModel.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/11.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseModel.h"

@interface FriendModel : TSBaseModel

@property (copy, nonatomic) NSString *userImageURL;
@property (copy, nonatomic) NSString *username;
@property (assign, nonatomic) BOOL isFriend;


@end
