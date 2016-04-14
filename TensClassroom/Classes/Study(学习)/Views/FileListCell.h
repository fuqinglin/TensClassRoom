//
//  FileListCell.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileModel;

@interface FileListCell : UITableViewCell

@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) FileModel *model;

@end
