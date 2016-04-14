//
//  QuestionListViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/23.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "QuestionListViewController.h"
#import "QuestionListCell.h"
#import "TSeachView.h"
#import "QuestionModel.h"

@interface QuestionListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_questions;
}
@property (strong, nonatomic) NSMutableArray *questionModelArray;

@end

@implementation QuestionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableHeaderAndFooter];
    
}

- (void)setTableHeaderAndFooter
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadQuestionDataIsMore:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadQuestionDataIsMore:YES];
    }];
}


- (void)loadNewQuestionData
{
    [self loadQuestionDataIsMore:NO];
}

#pragma mark - 获取问题数据
- (void)loadQuestionDataIsMore:(BOOL)isMore
{
    AVQuery *query = [AVQuery queryWithClassName:kTSAVObjectClass_Question];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    if (self.questionModelArray.count != 0) {
        
        if (isMore) {
            QuestionModel *model = [self.questionModelArray lastObject];
            [query whereKey:@"createdAt" lessThan:model.createAt];
            
        } else {
            
            QuestionModel *model = [self.questionModelArray firstObject];
            [query whereKey:@"createdAt" greaterThan:model.createAt];
        }
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count != 0) {
            NSMutableArray *newFiles = [[NSMutableArray alloc] initWithCapacity:objects.count];
            for (AVObject *object in objects) {
                QuestionModel *model = [[QuestionModel alloc] initWithAVObject:object];
                
                [newFiles addObject:model];
            }
            
            if (isMore) {
                
                [self.questionModelArray addObjectsFromArray:newFiles];
            } else {
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFiles.count)];
                [self.questionModelArray insertObjects:newFiles atIndexes:indexSet];
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

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionListCell"];
    QuestionModel *model = self.questionModelArray[indexPath.row];
    cell.model = model;
    cell.row = indexPath.row;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionModel *model = self.questionModelArray[indexPath.row];
    return model.textHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pushToDetailBlock) {
        QuestionModel *model = self.questionModelArray[indexPath.row];
        _pushToDetailBlock(model,indexPath.row);
    }
}


#pragma mark - 搜索
- (IBAction)searchBarAction:(id)sender {
    
    [[TSeachView shareSeachView] showSearchView];
}

#pragma mark - getMethots
-(NSMutableArray *)questionModelArray
{
    if (!_questionModelArray) {
        
        _questionModelArray = [[NSMutableArray alloc] init];
    }
    return _questionModelArray;
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
