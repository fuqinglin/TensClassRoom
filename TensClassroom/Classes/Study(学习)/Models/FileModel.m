//
//  FileModel.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (instancetype)initWithAVObject:(AVObject *)object
{
    if (self = [super initWithAVObject:object]) {
        
        self.fileContent = [object objectForKey:@"fileContent"];
    }
    
    return self;
}

@end
