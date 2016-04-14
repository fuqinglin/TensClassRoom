//
//  MessigeViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/7.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "MessageViewController.h"
#import "UUInputFunctionView.h"
#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
#import "ChatModel.h"
#import "FriendModel.h"
#import "NSDate+Formatter.h"
#import "TSAppDelegate.h"

static NSString *const cellID = @"messageCell";

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate,UUMessageCellDelegate,UUInputFunctionViewDelegate, AVIMClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UUInputFunctionView *inputView;
@property (strong, nonatomic) ChatModel *chatModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;
@property (strong, nonatomic) AVIMConversation *conversation;
@property (strong, nonatomic) FriendModel *currentUser;

@end

@implementation MessageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.username;
    [self addObservKeyboardChange];
    [self initViews];
    [self createConversation];
}

- (void)initViews
{
    self.chatModel = [[ChatModel alloc] init];
    self.currentUser = [[FriendModel alloc] initWithAVObject:[AVUser currentUser]];
    self.inputView = [[UUInputFunctionView alloc] initWithSuperVC:self];
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    
    [self.tableView registerClass:[UUMessageCell class] forCellReuseIdentifier:cellID];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadPastMessages];
    }];
}

#pragma mark - 监听键盘的通知
- (void)addObservKeyboardChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardChange:(NSNotification *)notification
{
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
       
        if (notification.name == UIKeyboardWillShowNotification) {
            
            self.inputView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
            
            self.tableBottomConstraint.constant = keyboardHeight + 40;
            
        } else {
            
            self.inputView.transform = CGAffineTransformIdentity;
            
            self.tableBottomConstraint.constant = 40;
        }
        
        [self.view layoutIfNeeded];

    }];
}

- (void)keyboardDidShow
{
    [self tableViewScrollToBottomAnimated:YES];
}

- (void)tableViewScrollToBottomAnimated:(BOOL)animate
{
    if (self.chatModel.dataSource.count==0) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:animate];
}

#pragma mark - 创建\查询会话
- (void)createConversation
{
    TSAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.client = appDelegate.client;
    self.client.delegate = self;
    
    AVIMConversationQuery *query = [self.client conversationQuery];
    NSString *conversationName = [NSString stringWithFormat:@"%@—%@",[AVUser currentUser].username,self.model.username];
    [query whereKey:@"m" containsAllObjectsInArray:@[[AVUser currentUser].username, self.model.username]];
    [query whereKey:@"m" sizeEqualTo:2];
    [query whereKey:AVIMAttr(@"customConversationType")  equalTo:@(1)];
    query.cacheMaxAge = 7 * 24 * 60 * 60;
    // [AVOSCloud setAllLogsEnabled:YES];
    
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        
        if (objects.count == 0) {
            NSDictionary *attributes = @{@"customConversationType": @(1)};
            [self.client createConversationWithName:conversationName clientIds:@[self.model.username] attributes:attributes options:AVIMConversationOptionNone callback:^(AVIMConversation *conversation, NSError *error) {
                if(error) return;
                
                self.conversation = conversation;
            }];
        } else {
            
            self.conversation = [objects firstObject];
            // 加载最近10条聊天记录
            [self loadLatestMessages];
        }
    }];
}

#pragma mark - 获取聊天记录
- (void)loadLatestMessages
{
    // 获取最后十条聊天记录
    NSArray *messages = [self.conversation queryMessagesFromCacheWithLimit:10];
    [self addMessages:messages isPast:YES];
}

- (void)loadPastMessages
{
    if (self.chatModel.dataSource.count == 0) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    // 获取早于第一条的消息
    UUMessageFrame *messsagFrame = [self.chatModel.dataSource firstObject];
    [self.conversation queryMessagesBeforeId:messsagFrame.message.strId timestamp:messsagFrame.message.sendTimestamp limit:5 callback:^(NSArray *objects, NSError *error) {
       
        [self addMessages:objects isPast:YES];
        [self.tableView.mj_header endRefreshing];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:objects.count inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

    }];
}


#pragma mark - 添加聊天消息
- (void)addMessages:(NSArray *)messages isPast:(BOOL)isPast
{
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    self.chatModel.provisionArray = [NSMutableArray arrayWithCapacity:messages.count];
    
    for (AVIMTypedMessage *message in messages) {
        
        [dataDic setObject:message.messageId forKey:@"strId"];
        [dataDic setObject:@(message.sendTimestamp) forKey:@"sendTimestamp"];
        [dataDic setObject:[[NSDate dateFromTimestamp:message.sendTimestamp] description] forKey:@"strTime"];
        
        if (message.ioType == AVIMMessageIOTypeIn) {
            [dataDic setObject:@(UUMessageFromOther) forKey:@"from"];
            [dataDic setObject:self.model.username forKey:@"strName"];
            [dataDic setObject:self.model.userImageURL forKey:@"strIcon"];
            
        } else {
            [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
            [dataDic setObject:self.currentUser.username forKey:@"strName"];
            [dataDic setObject:self.currentUser.userImageURL forKey:@"strIcon"];
        }
        
        switch (message.mediaType) {
            case kAVIMMessageMediaTypeText:
            {
                [dataDic setObject:@(UUMessageTypeText) forKey:@"type"];
                [dataDic setObject:message.text forKey:@"strContent"];
            }
                break;
            case kAVIMMessageMediaTypeImage:
            {
                [dataDic setObject:@(UUMessageTypePicture) forKey:@"type"];
                [dataDic setObject:message.file.url forKey:@"pictureURL"];
            }
                break;
            case kAVIMMessageMediaTypeAudio:
            {
                AVIMAudioMessage *audioMessage = (AVIMAudioMessage *)message;
                [dataDic setObject:@(UUMessageTypeVoice) forKey:@"type"];
                
                NSString *videoURL = audioMessage.file.url;
                if (videoURL == nil) videoURL = @"";
                [dataDic setObject:videoURL forKey:@"videoURL"];
                NSString *strVoiceTime = [NSString stringWithFormat:@"%.f",audioMessage.duration];
                [dataDic setObject:strVoiceTime forKey:@"strVoiceTime"];
            }
                break;
        }
        
        [self.chatModel addMessageItem:dataDic isPast:isPast];
    }
    
    if (!isPast) {
        [self.chatModel.dataSource addObjectsFromArray:self.chatModel.provisionArray];
        
    } else {
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.chatModel.provisionArray.count)];
        [self.chatModel.dataSource insertObjects:self.chatModel.provisionArray atIndexes:indexSet];
    }
    [self.tableView reloadData];
    
    [self tableViewScrollToBottomAnimated:!isPast];
}


#pragma mark - <AVIMClientDelegate> 接收消息
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message
{
    [self addMessages:@[message] isPast:NO];
}

#pragma mark - <UUInputFunctionViewDelegate> 发送消息
// 文本消息
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:message attributes:nil];
    [self.conversation sendMessage:textMessage callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            [self addMessages:@[textMessage] isPast:NO];
            funcView.TextViewInput.text = @"";
            [funcView changeSendBtnWithPhoto:YES];
        }
    }];
}

// 图片
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    AVFile *imageFile = [AVFile fileWithName:@"消息图片.jpg" data:UIImageJPEGRepresentation(image, 0.1)];
    NSString *text = [NSString stringWithFormat:@"来自：%@ ",self.currentUser.username];
    
    AVIMImageMessage *imageMessage = [AVIMImageMessage messageWithText:text file:imageFile attributes:nil];
    [self.conversation sendMessage:imageMessage callback:^(BOOL succeeded, NSError *error) {
        
        if(!succeeded){
            [self showTextHUD:error.localizedDescription];
        };
        
        [self addMessages:@[imageMessage] isPast:NO];
    }];
    
}

// 语音
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSString *)voicePath time:(NSInteger)second
{
    NSString *audioName = [NSString stringWithFormat:@"来自:%@.mp3",self.currentUser.username];
    AVFile *audioFile = [AVFile fileWithName:audioName contentsAtPath:voicePath];
    
    AVIMAudioMessage *audioMessage = [AVIMAudioMessage messageWithText:audioName file:audioFile attributes:nil];
    
    [self.conversation sendMessage:audioMessage callback:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"声音发送完成,%@",audioMessage.file.url);
        
        [self addMessages:@[audioMessage] isPast:NO];
    }];    
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.messageFrame = self.chatModel.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


#pragma mark - <UUMessageCellDelegate>
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId
{
    NSLog(@"点击头像");
}

- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage
{
    NSLog(@"点击消息");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
