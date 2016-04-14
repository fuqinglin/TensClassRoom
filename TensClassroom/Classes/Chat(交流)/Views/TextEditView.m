//
//  TextEditView.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/28.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "TextEditView.h"
#import <Masonry.h>

static TextEditView *editView = nil;
static UILabel *pLabel = nil;
static UIView *bgView = nil;
static UITextView *textView = nil;

@implementation TextEditView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

+ (instancetype)defaultEditeView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        editView = [[TextEditView alloc] initWithFrame:CGRectMake(0, 0, TSCREEN_WIDTH, TSCREEN_HEIGHT)];
        editView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [editView addSubEditViews];
    });
    
    return editView;
}


- (void)addSubEditViews
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, TSCREEN_HEIGHT - 150, TSCREEN_WIDTH, 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    [editView addSubview:bgView];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, TSCREEN_WIDTH, 110)];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.returnKeyType = UIReturnKeySend;
    [bgView addSubview:textView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bgView addSubview:cancelButton];
    cancelButton.frame = CGRectMake(TSCREEN_WIDTH - 70, 110, 60, 30);
    cancelButton.backgroundColor = BASE_COLOR;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    pLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 20)];
    pLabel.text = @"编辑文字...";
    pLabel.textColor = [UIColor lightGrayColor];
    pLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:pLabel];
    
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidChange:(UITextView *)textView
{
    pLabel.hidden = textView.hasText;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self hiden];
        
        if (self.sendTextHandle) {
            _sendTextHandle(textView.text);
        }
        
        textView.text = nil;
        NSLog(@"发送");
        return NO;
    }
    
    return YES;
}

#pragma mark - Actions
- (void)keyboardDidShow:(NSNotification *)info
{
    CGRect keyboardRect = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
       
        editView.alpha = 1;
        bgView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}

- (void)cancelAction
{
    textView.text = nil;
    [self hiden];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hiden];
}


#pragma mark - 显示、隐藏视图
- (void)show
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:editView];
        [textView becomeFirstResponder];
    });
}

- (void)hiden
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        editView.alpha = 0;
        bgView.transform = CGAffineTransformIdentity;
    }];

    [editView removeFromSuperview];
}

@end
