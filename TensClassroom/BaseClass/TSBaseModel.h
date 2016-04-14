//
//  TSBaseModel.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSBaseModel : NSObject

@property (copy, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSDate *createAt;
@property (copy, nonatomic) NSString *createDate;

- (instancetype)initWithAVObject:(AVObject *)object;

@end
