//
//  BlogListViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "BlogListViewController.h"
#import "BlogCell.h"
#import "BlogModel.h"

static NSString *const cellID = @"BlogCell";

@interface BlogListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *blogModelArray;
@property (assign, nonatomic) BOOL isMoreData;

@end

@implementation BlogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableViews];
}


- (void)initTableViews
{
    [self.tableView registerNib:[UINib nibWithNibName:@"BlogCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadBlogData];
    }];
    
     MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreBlogData];
    }];
    self.tableView.mj_footer = footer;
}

- (void)beginLoadData
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 加载博客数据
- (void)loadBlogData
{
    AVQuery *query = [AVQuery queryWithClassName:self.blogType];
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    if (self.blogModelArray.count != 0) {
        BlogModel *model = self.blogModelArray[0];
        [query whereKey:@"createdAt" greaterThan:model.createAt];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (objects.count != 0) {
            self.isMoreData = NO;
            [self objectToModel:objects];
            self.tableView.mj_footer.hidden = NO;
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreBlogData
{
    AVQuery *query = [AVQuery queryWithClassName:self.blogType];
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    if (self.blogModelArray.count != 0) {
        BlogModel *model = [self.blogModelArray lastObject];
        [query whereKey:@"createdAt" lessThan:model.createAt];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count != 0) {
            
            self.isMoreData = YES;
            [self objectToModel:objects];
            
        } else {
            
            self.tableView.mj_footer.hidden = YES;
        }
        
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)objectToModel:(NSArray *)objects
{
    NSMutableArray *newDateArray = [NSMutableArray arrayWithCapacity:objects.count];
    for (AVObject *object in objects) {
        
        BlogModel *model = [[BlogModel alloc] initWithAVObject:object];
        [newDateArray addObject:model];
    }
    
    if (_isMoreData) {
        [self.blogModelArray addObjectsFromArray:newDateArray];
    } else {
        NSRange range = NSMakeRange(0, newDateArray.count);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.blogModelArray insertObjects:newDateArray atIndexes:indexSet];
    }

    [self.tableView reloadData];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.blogModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.blogModelArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pushDetailBlock) {
        
        BlogModel *model = self.blogModelArray[indexPath.row];
        
        _pushDetailBlock(indexPath.row,model.blogDetailURL);
    }
    
}

#pragma mark - getMethod
- (NSMutableArray *)blogModelArray
{
    if (!_blogModelArray) {
        
        _blogModelArray = [[NSMutableArray alloc] init];
    }
    return _blogModelArray;
}

@end
