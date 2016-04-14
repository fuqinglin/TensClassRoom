//
//  VideoListViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoItemCell.h"
#import "VideoModel.h"

@interface VideoListViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *videoModelArray;
@property (nonatomic, assign) BOOL isMoreData;

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCollectionViews];
}

- (void)initCollectionViews
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadVideoData];

    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        [self loadMoreVideoData];
    }];
}

- (void)beginLoadData
{
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 获取视频数据
- (void)loadVideoData
{
    AVQuery *query = [AVQuery queryWithClassName:self.videoType];
    query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    [query orderByDescending:@"createdAt"];
    query.limit = 8;
    if (self.videoModelArray.count != 0) {
        VideoModel *model = self.videoModelArray[0];
        [query whereKey:@"createdAt" greaterThan:model.createAt];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (objects.count != 0) {
            self.isMoreData = NO;
            [self objectToModel:objects];
            
            self.collectionView.mj_footer.hidden = NO;
        }
        
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (void)loadMoreVideoData
{
    AVQuery *query = [AVQuery queryWithClassName:self.videoType];
    query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    [query orderByDescending:@"createdAt"];
    query.limit = 8;
    if (self.videoModelArray.count != 0) {
        VideoModel *model = [self.videoModelArray lastObject];
        [query whereKey:@"createdAt" lessThan:model.createAt];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count != 0) {
            self.isMoreData = YES;
            [self objectToModel:objects];
            
        } else {
            
            self.collectionView.mj_footer.hidden = YES;
        }
        
        [self.collectionView.mj_footer endRefreshing];
    }];
}


- (void)objectToModel:(NSArray *)objects
{
    NSMutableArray *newVideos = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for (AVObject *object in objects) {
        
        VideoModel *model = [[VideoModel alloc] initWithAVObject:object];
        [newVideos addObject:model];
    }
    
    if (_isMoreData) {
        
        [self.videoModelArray addObjectsFromArray:newVideos];
    } else {
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newVideos.count)];
        [self.videoModelArray insertObjects:newVideos atIndexes:indexSet];
    }
    
    [self.collectionView reloadData];
}


#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoItemCell" forIndexPath:indexPath];
    
    cell.model = self.videoModelArray[indexPath.row];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (TSCREEN_WIDTH - 45) / 2;
    CGFloat itemHeight = itemWidth * 4 / 5.0;
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pushToPlayerVideoBlock) {
        
        VideoModel *model = self.videoModelArray[indexPath.row];
        NSString *videoPlayURL = model.videoPlayURL;
        _pushToPlayerVideoBlock(indexPath.item,videoPlayURL);
    }
    
}

#pragma mark - getMethod
- (NSMutableArray *)videoModelArray
{
    if (!_videoModelArray) {
        
        _videoModelArray = [[NSMutableArray alloc] init];
    }
    return _videoModelArray;
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
