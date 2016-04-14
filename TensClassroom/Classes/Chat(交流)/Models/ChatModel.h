//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *provisionArray;

@property (nonatomic) BOOL isGroupChat;

/** 添加消息，判断是及时消息还是历史消息记录**/
- (void)addMessageItem:(NSDictionary *)dic isPast:(BOOL)isPast;

@end
