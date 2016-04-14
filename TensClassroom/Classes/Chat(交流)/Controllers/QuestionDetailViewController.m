//
//  QuestionDetailViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/28.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QuestionDetailCell.h"
#import "QuestionModel.h"
#import "AnswerCell.h"
#import "TextEditView.h"
#import "CommentModel.h"

@interface QuestionDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *commentModelArray;
@property (strong, nonatomic) AVObject *questionObj;

@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableHeaderAndFooter];
    [self changeScanCount];
    
}

- (void)setTableHeaderAndFooter
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadCommentDataIsMore:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadCommentDataIsMore:YES];
    }];
}


- (void)loadNewQuestionData
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 回答问题
- (IBAction)answerButtonAction:(UIButton *)sender {
    
    TextEditView *editView = [TextEditView defaultEditeView];
    [editView setSendTextHandle:^(NSString *text) {
       
        [self showHUD:@"提交中..."];
        AVObject *commentObj = [AVObject objectWithClassName:kTSAVObjectClass_Comment];
        [commentObj setObject:text forKey:@"commentContent"];
        [commentObj setObject:[AVUser currentUser].username forKey:@"commentUserName"];
        [commentObj setObject:[[AVUser currentUser] objectForKey:@"userImage"] forKey:@"userImage"];
        [commentObj setObject:self.questionObj forKey:@"questionObject"];
        
        [commentObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           
            if (!succeeded) {
                [self hiddenHUD];
                [self showTextHUD:error.localizedDescription];
            } else {
                
                [self.questionObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(!succeeded) return;
                    
                    [self changeAnswerCount];
                }];
            }
        }];
    
    }];
    
    [editView show];
}

#pragma mark - 修改回答数/浏览数
- (void)changeAnswerCount
{
    NSString *count = [NSString stringWithFormat:@"%ld",[self.model.answerCount integerValue] + 1];
    [self.questionObj setObject:count forKey:@"answerCount"];
    [self.questionObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self hiddenHUD];
        [self showCustomHUD:@"回答完成!"];
        [self loadCommentDataIsMore:NO];
        
        // 修改model的回答数
        self.model.answerCount = count;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
        // 刷新问题列表数据
        if (self.changAnswerOrScanHandle) {
            _changAnswerOrScanHandle();
        }
        
    }];
}

- (void)changeScanCount
{
    // 修改问题浏览数
    self.questionObj = [AVObject objectWithoutDataWithClassName:kTSAVObjectClass_Question objectId:_model.objectId];
    [self.questionObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!succeeded) return;
        
        NSInteger scanCount = [self.model.scanCount intValue];
        NSString *count = [NSString stringWithFormat:@"%ld",scanCount + 1];
        [self.questionObj setObject:count forKey:@"scanCount"];
        [self.questionObj saveInBackground];
        
        // 修改model的浏览数
        self.model.scanCount = count;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
        // 刷新问题列表数据
        if (self.changAnswerOrScanHandle) {
            _changAnswerOrScanHandle();
        }
    }];
}

#pragma mark - 获取回答数据
- (void)loadCommentDataIsMore:(BOOL)isMore
{
    // 获取评论数据
    AVQuery *query = [AVQuery queryWithClassName:kTSAVObjectClass_Comment];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"questionObject" equalTo:self.questionObj];
    if (self.commentModelArray.count != 0) {
        
        if (isMore) {
            CommentModel *model = [self.commentModelArray lastObject];
            [query whereKey:@"createdAt" lessThan:model.createAt];
            
        } else {
            
            CommentModel *model = [self.commentModelArray firstObject];
            [query whereKey:@"createdAt" greaterThan:model.createAt];
        }
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count != 0) {
            NSMutableArray *newFiles = [[NSMutableArray alloc] initWithCapacity:objects.count];
            for (AVObject *object in objects) {
                CommentModel *model = [[CommentModel alloc] initWithAVObject:object];
                
                [newFiles addObject:model];
            }
            
            if (isMore) {
                
                [self.commentModelArray addObjectsFromArray:newFiles];
            } else {
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFiles.count)];
                [self.commentModelArray insertObjects:newFiles atIndexes:indexSet];
                self.tableView.mj_footer.hidden = NO;
            }
            
        } else {
            
            if (isMore) self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    return self.commentModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        QuestionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionDetailCell" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }
    
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnswerCell" forIndexPath:indexPath];
    cell.model = self.commentModelArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return _model.textHeight + 70;
    }
    
    CommentModel *model = self.commentModelArray[indexPath.row];
    return model.commentTextHeight ;
}

#pragma mark - getMethod
- (NSMutableArray *)commentModelArray
{
    if (!_commentModelArray) {
        
        _commentModelArray = [[NSMutableArray alloc] init];
    }
    return _commentModelArray;
}


@end
