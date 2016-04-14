//
//  BlogDetailViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/28.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "BlogDetailViewController.h"

@interface BlogDetailViewController () <UIWebViewDelegate>

@property (weak, nonatomic)IBOutlet UIWebView *webView;

@end

@implementation BlogDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.scrollView.bounces = NO;
    [self loadHTML];
    
}

- (void)loadHTML
{
    NSURL *url = [NSURL URLWithString:self.blogDetailURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"开始加载数据");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"数据加载完成！");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"加载出错 %@",error);
}


@end
