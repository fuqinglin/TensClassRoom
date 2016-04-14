//
//  NSString+FilePath.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "NSString+FilePath.h"

@implementation NSString (FilePath)

- (NSString *)pathFromFileID
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",self];
    NSString *fileSavePath = [documentPath stringByAppendingPathComponent:fileName];
    
    return fileSavePath;
}

- (BOOL)hasFile
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager fileExistsAtPath:[self pathFromFileID]];
}

- (void)deleteFileFromFileID
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:[self pathFromFileID] error:nil];
}


@end
