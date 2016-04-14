//
//  MessigeViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/7.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
@class FriendModel;

@interface MessageViewController : TSBaseViewController

@property (strong, nonatomic) AVIMClient *client;
@property (strong, nonatomic) FriendModel *model;

@end
