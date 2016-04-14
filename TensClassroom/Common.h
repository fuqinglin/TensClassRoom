//
//  Header.h
//  TensClassroom
//
//  Created by qinglinfu on 16/3/30.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define BASE_COLOR [UIColor colorWithRed:87/255.0 green:194/255.0 blue:192/255.0 alpha:1]
#define BG_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]


#define TSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define TSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//----------------------AVOSCloud授权码----------------------------
#define APP_ID @"PnuWJNRERioyynsBcGUXBsrC-gzGzoHsz"
#define APP_KEY @"FIOD0yoUUhEUdeDPjxrxAHVG"
#define MASTERKEY @"4ra75Api85KK6UYEHSGvwyiL"

// ----------------------AVOSCloud数据类名-------------------------
static NSString *const kTSAVObjectClass_HomeBlog = @"iOS_BlogList"; // 首页推荐博客列表
static NSString *const kTSAVObjectClass_iOSBlog = @"iOS_Blog";      // iOS博客
static NSString *const kTSAVObjectClass_CVideo = @"C_Video";        // C语言视频
static NSString *const kTSAVObjectClass_CFile = @"C_File";          // C语言文件
static NSString *const kTSAVObjectClass_Question = @"All_Question"; // 提问
static NSString *const kTSAVObjectClass_Comment = @"All_Comment";   // 评论
static NSString *const kTSAVObjectClass_User = @"_User";            // 用户

//----------------------通知名称-----------------------------------
static NSString *const kTSLoginSuccessNotification = @"LoginSuccess";             // 登录成功
static NSString *const kTSFileDownLoadFinishNotification = @"FileDownLoadFinish"; // 文件下载完成
static NSString *const kTSQuestionAnswerFinishNotification = @"QuestionAnswer";   // 问题回答完成
static NSString *const kTSQusstionScanFinishNotification = @"QusstionScan";     // 问题浏览完成


#endif /* Header_h */

