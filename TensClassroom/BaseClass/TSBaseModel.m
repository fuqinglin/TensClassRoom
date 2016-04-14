//
//  TSBaseModel.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseModel.h"

@implementation TSBaseModel

- (instancetype)initWithAVObject:(AVObject *)object
{
    if (self = [super init]) {
        
        NSDictionary *objectDic = [object dictionaryForObject];
        [self setValuesForKeysWithDictionary:objectDic];
        
        self.createAt = object.createdAt;
        self.createDate = [self.createAt formatToString];
    }
    
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
