//
//  VideoListViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"

@interface VideoListViewController : TSBaseViewController

@property(nonatomic, copy)void (^pushToPlayerVideoBlock)(NSInteger item,NSString *videoPlayURL);
@property (copy, nonatomic) NSString *videoType;

- (void)beginLoadData;

@end
