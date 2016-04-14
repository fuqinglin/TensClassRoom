//
//  NSString+FilePath.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FilePath)

/** 根据file的ID创建保存的路径 **/
- (NSString *)pathFromFileID;

/** 根据fileID 判断是否存在该文件 **/
- (BOOL)hasFile;

/** 根据 fileID 删除本地的file **/
- (void)deleteFileFromFileID;


@end
