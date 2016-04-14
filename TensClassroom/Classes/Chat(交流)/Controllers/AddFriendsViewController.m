//
//  AddFriendsViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/11.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "TSearchBar.h"
#import "AddFriendCell.h"
#import "FriendModel.h"
#import "TSAlertView.h"

@interface AddFriendsViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friendArray;
@property (strong, nonatomic) NSArray *friendNames;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.placeholder = @"输入好友的昵称";
    self.searchBar.delegate = self;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    cell.model = self.friendArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendModel *model = self.friendArray[indexPath.row];
    if(model.isFriend) return;
    
    NSString *message = [NSString stringWithFormat:@"确定添加< %@ > 为好友？",model.username];
    [TSAlertView showMessage:message handler:^{
       
        [self addFriends:model];
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length == 0) return NO;
    
    [self searchFriends];
    
    return YES;
}

#pragma mark - 查询符合条件的好友\添加好友
- (void)searchFriends
{
    [self.friendArray removeAllObjects];
    _friendNames = [[AVUser currentUser] objectForKey:@"userFriends"];

    AVQuery *query = [AVQuery queryWithClassName:kTSAVObjectClass_User];
    [query whereKey:@"username" containsString:_searchBar.text];
    [query whereKey:@"username" notEqualTo:[AVUser currentUser].username];
    
    [self showHUD:@"查询中..."];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [self hiddenHUD];
        
        if(objects.count == 0) return;
        
        [self objectsToModel:objects];
        
        [self.tableView reloadData];
    }];
}

- (void)objectsToModel:(NSArray *)objects
{
    for (AVUser *user in objects) {
        
        FriendModel *model = [[FriendModel alloc] initWithAVObject:user];
        if([_friendNames containsObject:model.username]){
            model.isFriend = YES;
        };
        
        [self.friendArray addObject:model];
    }
}

- (void)addFriends:(FriendModel *)model
{
    [[AVUser currentUser] addUniqueObject:model.username forKey:@"userFriends"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if(!succeeded) return;
        
        [self showCustomHUD:@"添加成功!"];
        model.isFriend = YES;
        [self.tableView reloadData];
        
        if (self.addFridendSuccessHandle) {
            
            _addFridendSuccessHandle(model);
        }
    }];
}


#pragma mark - getMethods
- (NSMutableArray *)friendArray
{
    if (!_friendArray) {
        
        _friendArray = [[NSMutableArray alloc] init];
    }
    return _friendArray;
}



@end
