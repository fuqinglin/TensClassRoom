//
//  FriendListViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/23.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
@class FriendModel;

@interface FriendListViewController : TSBaseViewController

@property (nonatomic, copy) void(^pushHandel)(FriendModel *model);

/* 添加新的好友后刷新好友列表 */
- (void)refreshFriendList:(FriendModel *)model;

@end
