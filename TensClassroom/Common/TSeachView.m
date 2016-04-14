//
//  TSeachView.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TSeachView.h"
#import "TSearchBar.h"

@implementation TSeachView

static TSeachView *seachView = nil;
static UIView *topView = nil;
static TSearchBar *searchBar = nil;
static UIVisualEffectView *effecView = nil;


+ (instancetype)shareSeachView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        seachView = [[self alloc] initWithFrame:CGRectMake(0, 0, TSCREEN_WIDTH, TSCREEN_HEIGHT)];
        seachView.alpha = 0;
        [seachView creatSeachBar];
        
    });
    
    return seachView;
}


- (void)creatSeachBar
{
    // 毛玻璃效果
    effecView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effecView.frame = seachView.bounds;
    [seachView addSubview:effecView];
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, TSCREEN_WIDTH, 64)];
    topView.backgroundColor = BASE_COLOR;
    
    searchBar = [[TSearchBar alloc] initWithFrame:CGRectMake(20, 25, TSCREEN_WIDTH - 80, 30)];
    [topView addSubview:searchBar];
    
    UIButton *cacelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cacelButton.frame = CGRectMake(TSCREEN_WIDTH - 60, 25, 50, 35);
    [cacelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cacelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cacelButton addTarget:self action:@selector(cacelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:cacelButton];
    
    [seachView addSubview:topView];
}

- (void)cacelButtonAction
{
    [self endEditing:YES];
    [self hideSearchView];
}


- (void)showSearchView
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:seachView];
    
    [UIView animateWithDuration:0.5 animations:^{
       
        topView.transform = CGAffineTransformMakeTranslation(0, 64);
        seachView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
    
        [searchBar becomeFirstResponder];
    }];
}

- (void)hideSearchView
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        topView.transform = CGAffineTransformIdentity;
        seachView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [seachView removeFromSuperview];

    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


@end
