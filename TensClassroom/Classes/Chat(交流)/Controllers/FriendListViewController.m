//
//  FriendListViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/23.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "FriendListViewController.h"
#import "FriendListCell.h"
#import "FriendModel.h"
#import "TSeachView.h"

@interface FriendListViewController ()<UITableViewDelegate, UITableViewDataSource,AVIMClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *friendsArray;

@end

@implementation FriendListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听登录成功后加载当前用户的好友
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserFriendsList) name:kTSLoginSuccessNotification object:nil];
    
    [self loadUserFriendsList];
}

#pragma mark - 获取好友列表
- (void)loadUserFriendsList
{
    [self.friendsArray removeAllObjects];
    NSArray *friendNames = [[AVUser currentUser] objectForKey:@"userFriends"];
    if (friendNames.count == 0) {
        [self.tableView reloadData];
        return;
    }
    
    AVQuery *query = [AVQuery queryWithClassName:kTSAVObjectClass_User];
    query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    [query whereKey:@"username" containedIn:friendNames];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if(error) return;
        
        for (AVObject *obj in objects) {
            
            FriendModel *model = [[FriendModel alloc] initWithAVObject:obj];
            
            [self.friendsArray insertObject:model atIndex:0];
        }
        
        [self.tableView reloadData];

    }];
}


- (void)refreshFriendList:(FriendModel *)model
{
    [self.friendsArray insertObject:model atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendListCell" forIndexPath:indexPath];
    cell.model = self.friendsArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pushHandel) {
        
        FriendModel *model = self.friendsArray[indexPath.row];
        _pushHandel(model);
    }
}


- (IBAction)searchBarAction:(id)sender {
    
    [[TSeachView shareSeachView] showSearchView];

}

- (NSMutableArray *)friendsArray
{
    if (!_friendsArray) {
        
        _friendsArray = [[NSMutableArray alloc] init];
    }
    return _friendsArray;
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
