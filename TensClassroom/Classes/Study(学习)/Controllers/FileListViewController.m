//
//  FileListViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "FileListViewController.h"
#import "FileListCell.h"
#import "FileModel.h"

@interface FileListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *fileModelArray;

@end

@implementation FileListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableHeaderAndFooter];
}


- (void)setTableHeaderAndFooter
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadFileDataIsMore:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadFileDataIsMore:YES];
    }];
}

#pragma mark - 加载文件数据
- (void)loadFileDataIsMore:(BOOL)isMore
{
    AVQuery *query = [AVQuery queryWithClassName:self.fileType];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    if (self.fileModelArray.count != 0) {
        
        if (isMore) {
            FileModel *model = [self.fileModelArray lastObject];
            [query whereKey:@"createdAt" lessThan:model.createAt];
            
        } else {
            
            FileModel *model = [self.fileModelArray firstObject];
            [query whereKey:@"createdAt" greaterThan:model.createAt];
        }
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count != 0) {
            NSMutableArray *newFiles = [[NSMutableArray alloc] initWithCapacity:objects.count];
            for (AVObject *object in objects) {
                FileModel *model = [[FileModel alloc] initWithAVObject:object];
                [newFiles addObject:model];
            }
            
            if (isMore) {
                
                [self.fileModelArray addObjectsFromArray:newFiles];
            } else {
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFiles.count)];
                [self.fileModelArray insertObjects:newFiles atIndexes:indexSet];
                self.tableView.mj_footer.hidden = NO;
            }
            
        } else {
            
            if (isMore) self.tableView.mj_footer.hidden = YES;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    }];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileListCell" forIndexPath:indexPath];
    cell.model = self.fileModelArray[indexPath.row];
    cell.row = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pushDetailBlock) {
        
        FileModel *model = self.fileModelArray[indexPath.row];
        _pushDetailBlock(indexPath.row, model);
    }
}

#pragma mark - getMethod
- (NSMutableArray *)fileModelArray
{
    if (!_fileModelArray) {
        
        _fileModelArray = [[NSMutableArray alloc] init];
    }
    return _fileModelArray;
}


@end
