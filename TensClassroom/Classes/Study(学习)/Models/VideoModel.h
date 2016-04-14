//
//  VideoModel_.h
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSBaseModel.h"

@interface VideoModel : TSBaseModel

@property (copy, nonatomic) NSString *videoTitle;
@property (strong, nonatomic) AVFile *videoImage;
@property (copy, nonatomic) NSString *videoPlayURL;

@end
