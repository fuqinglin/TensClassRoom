//
//  FileListViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
@class FileModel;

@interface FileListViewController : TSBaseViewController

@property (copy, nonatomic) NSString *fileType;
@property (nonatomic, copy) void(^pushDetailBlock)(NSInteger row, FileModel *model);


@end
