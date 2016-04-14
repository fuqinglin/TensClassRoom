//
//  StudyItemListViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "StudyItemListViewController.h"
#import "FileListViewController.h"
#import "BlogListViewController.h"
#import "VideoListViewController.h"
#import "FileDetailViewController.h"
#import "BlogDetailViewController.h"
#import "VideoPlayerViewController.h"
#import "TSeachView.h"
#import <Masonry.h>


@interface StudyItemListViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) BOOL isFirstLoad;

@property (strong, nonatomic) UIStoryboard *studyStoryboard;
@property (strong, nonatomic) FileListViewController *fileListVC;
@property (strong, nonatomic) BlogListViewController *blogListVC;
@property (strong, nonatomic) VideoListViewController *videoListVC;

@end

@implementation StudyItemListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViewControllers];
    [self controllerPushHandles];
}


#pragma mark - 添加管理视图
- (void)addViewControllers
{
    self.isFirstLoad = YES;

    _studyStoryboard = [UIStoryboard storyboardWithName:@"Study" bundle:nil];
    
    self.fileListVC = [_studyStoryboard instantiateViewControllerWithIdentifier:@"FileListViewController"];
    self.fileListVC.fileType = self.fileType;
    
    self.blogListVC = [_studyStoryboard instantiateViewControllerWithIdentifier:@"BlogListViewController"];
    self.blogListVC.blogType = self.blogType;
    
    self.videoListVC = [_studyStoryboard instantiateViewControllerWithIdentifier:@"VideoListViewController"];
    self.videoListVC.videoType = self.videoType;
    
    [self.scrollView addSubview:self.fileListVC.view];
    [self.scrollView addSubview:self.blogListVC.view];
    [self.scrollView addSubview:self.videoListVC.view];
}

#pragma mark - handleBlocks
- (void)controllerPushHandles
{
    __weak typeof(self)weakSelf = self;
    
    [self.fileListVC setPushDetailBlock:^(NSInteger row, FileModel *model) {
       
        FileDetailViewController *fileDetailVC = [weakSelf.studyStoryboard instantiateViewControllerWithIdentifier:@"FileDetailViewController"];
        fileDetailVC.model = model;
        fileDetailVC.row = row;
        [weakSelf.navigationController pushViewController:fileDetailVC animated:YES];
    }];
    
    
    [self.blogListVC setPushDetailBlock:^(NSInteger row, NSString *blogDetailURL) {
       
        BlogDetailViewController *blogDetailVC = [weakSelf.studyStoryboard instantiateViewControllerWithIdentifier:@"BlogDetailViewController"];
        blogDetailVC.blogDetailURL = blogDetailURL;
        [weakSelf.navigationController pushViewController:blogDetailVC animated:YES];
    }];
    
    [self.videoListVC setPushToPlayerVideoBlock:^(NSInteger item, NSString *videoPlayURL) {
        
        VideoPlayerViewController *videoPlayerVC = [weakSelf.studyStoryboard instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
        videoPlayerVC.videoPlayURL = videoPlayURL;
        [weakSelf.navigationController pushViewController:videoPlayerVC animated:YES];
    }];
}


#pragma mark - 设置约束
- (void)updateViewConstraints
{
    [self.fileListVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self.scrollView);
        make.top.bottom.width.equalTo(self.scrollView);
        
    }];
 
    [self.blogListVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.fileListVC.view.mas_right);
        
        make.top.bottom.width.equalTo(self.scrollView);
    }];
    
    
    [self.videoListVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.blogListVC.view.mas_right);
        make.top.bottom.right.equalTo(self.scrollView);
    }];
 
    [super updateViewConstraints];

}
- (IBAction)searchItemAction:(UIBarButtonItem *)sender {
    
    [[TSeachView shareSeachView] showSearchView];
}



#pragma mark - 切换页面
- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    
    [self.scrollView setContentOffset:CGPointMake(TSCREEN_WIDTH * sender.selectedSegmentIndex, 0) animated:YES];
    
    [self loadDataForPage:sender.selectedSegmentIndex];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger currentPage = targetContentOffset->x / TSCREEN_WIDTH;
    [self loadDataForPage:currentPage];

    [UIView animateWithDuration:0.5 animations:^{
       
        self.segmentedControl.selectedSegmentIndex = currentPage;
    }];
}


- (void)loadDataForPage:(NSInteger)page
{
    if (_isFirstLoad) {
        
        if (page == 1) {
            [self.blogListVC beginLoadData];
            
        } else if(page == 2 ) {
            [self.videoListVC beginLoadData];
        }
        
        _isFirstLoad = NO;
    }
}


@end
