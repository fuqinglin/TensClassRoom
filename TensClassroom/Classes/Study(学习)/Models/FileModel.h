//
//  FileModel.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseModel.h"

@interface FileModel : TSBaseModel

@property (copy, nonatomic) NSString *fileName;
@property (strong, nonatomic) AVFile *fileContent;

@end
