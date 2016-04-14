//
//  FileDetailViewController.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseViewController.h"
@class FileModel;

@interface FileDetailViewController : TSBaseViewController

@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) FileModel *model;

@end
