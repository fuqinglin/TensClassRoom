//
//  AddFriendsViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/11.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
@class FriendModel;

@interface AddFriendsViewController : TSBaseViewController

@property (copy, nonatomic)void(^addFridendSuccessHandle)(FriendModel *model);

@end
