//
//  ChatViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/22.
//  Copyright © 2016年 十安科技. All rights reserved.
//


#import "ChatViewController.h"
#import "FriendListViewController.h"
#import "AddFriendsViewController.h"
#import "QuestionListViewController.h"
#import "QuestionDetailViewController.h"
#import "MessageViewController.h"
#import "TextEditView.h"
#import <Masonry.h>
#import "TSPopView.h"
#import "AddListView.h"

typedef NS_ENUM(NSInteger, RigthButtonType){
    RigthButtonTypeIsAdd = 0,
    RigthButtonTypeIsQuestion
};

@interface ChatViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *rightItemButton;
@property (strong, nonatomic) UIStoryboard *chatStoryboard;
@property (strong, nonatomic) FriendListViewController *friendListVC;
@property (strong, nonatomic) QuestionListViewController *questionListVC;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControllerViews];
    [self pushActionHandle];
}


#pragma mark - 添加管理页面视图
- (void)addControllerViews
{
    _chatStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    self.friendListVC = [_chatStoryboard instantiateViewControllerWithIdentifier:@"FriendListViewController"];
    self.questionListVC = [_chatStoryboard instantiateViewControllerWithIdentifier:@"QuestionListViewController"];
   
    [self.scrollView addSubview:self.friendListVC.view];
    [self.scrollView addSubview:self.questionListVC.view];
}

- (void)updateViewConstraints {
    
    [self.friendListVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.scrollView);
        make.top.bottom.width.equalTo(self.scrollView);
        
    }];
    
    [self.questionListVC.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.friendListVC.view.mas_trailing);
        make.top.bottom.width.equalTo(self.scrollView);
    }];

    
    [super updateViewConstraints];
}

#pragma mark - Actions
- (IBAction)segmentSelectAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        [self.rightItemButton setImage:[UIImage imageNamed:@"添加好友"] forState:UIControlStateNormal];
        self.rightItemButton.tag = RigthButtonTypeIsAdd;
        
    } else {
        
        [self.scrollView setContentOffset:CGPointMake(TSCREEN_WIDTH, 0) animated:YES];
        [self.rightItemButton setImage:[UIImage imageNamed:@"添加问题"] forState:UIControlStateNormal];
        self.rightItemButton.tag = RigthButtonTypeIsQuestion;
    }
}

- (IBAction)rightButtonAction:(UIButton *)sender {
    
    if (sender.tag == RigthButtonTypeIsAdd) {
        
        [self showAddItems];
        
    } else if(sender.tag == RigthButtonTypeIsQuestion) {
        
        [self showEditView];
    }
}

// 添加选项
- (void)showAddItems
{
    TSPopView *popView = [TSPopView creat];
    AddListView *addView = [[AddListView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [addView setAddButtonHandle:^(AddButtonType buttonType) {
        
        switch (buttonType) {
            case AddButtonTypeAddFriend:
            {
                [popView removeFromSuperview];
                AddFriendsViewController *addfriendsVC = [_chatStoryboard instantiateViewControllerWithIdentifier:@"AddFriendsViewController"];
                [addfriendsVC setAddFridendSuccessHandle:^(FriendModel *model) {
                    
                    [self.friendListVC refreshFriendList:model];
                }];
                [self.navigationController pushViewController:addfriendsVC animated:YES];
            }
                break;
            case AddButtonTypeGroup:
                
                NSLog(@"创建群聊");
                break;
        }
    }];
    
    popView.contentView = addView;
    [popView showPopView:_rightItemButton withType:PopViewIsRight];
}

// 显示编辑视图
- (void)showEditView
{
    TextEditView *editView = [TextEditView defaultEditeView];
    
    [editView setSendTextHandle:^(NSString *text) {
        
        [self showHUD:@"提交中..."];
        
        AVObject *questionObj = [AVObject objectWithClassName:kTSAVObjectClass_Question];
        [questionObj setObject:text forKey:@"questionTitle"];
        [questionObj setObject:[AVUser currentUser].username forKey:@"authorName"];
        [questionObj setObject:@"0" forKey:@"answerCount"];
        [questionObj setObject:@"0" forKey:@"scanCount"];
        
        [questionObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!succeeded) return;
            
            [self hiddenHUD];
            [self showCustomHUD:@"提交成功"];
            [self.questionListVC loadNewQuestionData];
            
        }];
    }];
    [editView show];
}

#pragma mark - pushActionHandle
- (void)pushActionHandle
{
    __weak typeof(self)weakSelf = self;
    
    [self.questionListVC setPushToDetailBlock:^(QuestionModel *model,NSInteger row) {
       
        QuestionDetailViewController *questionDetailVC = [weakSelf.chatStoryboard instantiateViewControllerWithIdentifier:@"QuestionDetailViewController"];
        questionDetailVC.model = model;
        [questionDetailVC setChangAnswerOrScanHandle:^{
           
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [weakSelf.questionListVC.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [weakSelf.navigationController pushViewController:questionDetailVC animated:YES];
    }];
    
    
    [self.friendListVC setPushHandel:^(FriendModel *model){
       
        MessageViewController *messigeVC = [weakSelf.chatStoryboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
        messigeVC.model = model;
        [weakSelf.navigationController pushViewController:messigeVC animated:YES];
    }];
}

#pragma mark - <UIScrollViewDelegate,UITextFieldDelegate>
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offset_x = targetContentOffset->x;
    NSInteger currentItem = offset_x / TSCREEN_WIDTH;

    [UIView animateWithDuration:0.5 animations:^{
    
        self.segmentedControl.selectedSegmentIndex = currentItem;
        
    } completion:^(BOOL finished) {
        
        NSArray *imageNames = @[@"添加好友",@"添加问题"];
        [self.rightItemButton setImage:[UIImage imageNamed:imageNames[currentItem]] forState:UIControlStateNormal];
        self.rightItemButton.tag = currentItem;
    }];
}


@end
