//
//  StudyViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/22.
//  Copyright © 2016年 十安科技. All rights reserved.
//


#import "StudyViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "BlogCell.h"
#import "StudyItemListViewController.h"
#import "BlogDetailViewController.h"
#import "BlogModel.h"

typedef NS_ENUM(NSInteger, StudyItemType) {
    
    StudyItemTypeIsC = 0,
    StudyItemTypeIsOC,
    StudyItemTypeIsUI,
    StudyItemTypeIsSwift,
    StudyItemTypeIsAdvanced,
    StudyItemTypeIsProject
};

static NSString *const cellID = @"BlogCell";

@interface StudyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIStoryboard *studyStoryboard;
@property (strong, nonatomic) NSMutableArray *blogLists;

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)initSubViews
{
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 0, 230);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BlogCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.studyStoryboard = [UIStoryboard storyboardWithName:@"Study" bundle:nil];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadBlogListData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Actions
- (IBAction)openDrawerAction:(UIBarButtonItem *)sender {
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}


- (IBAction)messageItemAction:(UIBarButtonItem *)sender {
    
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    StudyItemListViewController *studyListVC = [_studyStoryboard instantiateViewControllerWithIdentifier:@"StudyItemListViewController"];
    
    switch (sender.tag) {
        case StudyItemTypeIsC:
            studyListVC.title = @"C语言";
            studyListVC.videoType = kTSAVObjectClass_CVideo;
            studyListVC.fileType = kTSAVObjectClass_CFile;
            break;
            
        case StudyItemTypeIsOC:
            
            studyListVC.title = @"OC";
            break;
            
        case StudyItemTypeIsUI:
            
            studyListVC.title = @"UI";
            break;
        
        case StudyItemTypeIsSwift:
            
            studyListVC.title = @"Swift";
            break;
        case StudyItemTypeIsAdvanced:
            
            studyListVC.title = @"iOS进阶";
            studyListVC.blogType = kTSAVObjectClass_iOSBlog;
            break;
            
        case StudyItemTypeIsProject:
            
            studyListVC.title = @"项目实践";
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:studyListVC animated:YES];
    
}

#pragma mark - 网络加载博客数据
- (void)loadBlogListData
{
    AVQuery *query = [AVQuery queryWithClassName:kTSAVObjectClass_HomeBlog];
    query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    [query orderByDescending:@"createdAt"];
    if (self.blogLists.count != 0) {
        
        BlogModel *firstBlog = [self.blogLists firstObject];
        [query whereKey:@"createdAt" greaterThan:firstBlog.createAt];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (objects.count > 0) {
            
            NSMutableArray *newBlogs = [[NSMutableArray alloc] initWithCapacity:objects.count];
            
            for (AVObject *object in objects) {
                
                BlogModel *model = [[BlogModel alloc] initWithAVObject:object];
                [newBlogs addObject:model];
            }
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newBlogs.count)];
            [self.blogLists insertObjects:newBlogs atIndexes:indexSet];
            
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_header endRefreshing];

    }];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.blogLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.blogLists[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BlogDetailViewController *blogDetailVC = [_studyStoryboard instantiateViewControllerWithIdentifier:@"BlogDetailViewController"];
    BlogModel *model = self.blogLists[indexPath.row];
    blogDetailVC.blogDetailURL = model.blogDetailURL;
    
    [self.navigationController pushViewController:blogDetailVC animated:YES];
}

#pragma mark - getMethods
- (NSMutableArray *)blogLists
{
    if (!_blogLists) {
        
        _blogLists = [[NSMutableArray alloc] init];
    }
    return _blogLists;
}


@end
