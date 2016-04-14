//
//  BlogListViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"

@interface BlogListViewController : TSBaseViewController

@property (nonatomic, copy) void(^pushDetailBlock)(NSInteger row, NSString *blogDetailURL);
@property (copy, nonatomic) NSString *blogType;

- (void)beginLoadData;

@end
