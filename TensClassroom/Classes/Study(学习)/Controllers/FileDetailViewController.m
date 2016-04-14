//
//  FileDetailViewController.m
//  TensClassroom
//
//  Created by qinglinfu on 16/4/1.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "FileDetailViewController.h"
#import "NSString+FilePath.h"
#import "FileModel.h"
#import "DownLoadProgressView.h"

@interface FileDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet DownLoadProgressView *progressView;

@end

@implementation FileDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.model.fileName;
    
    if ([self.model.objectId hasFile]) {
        
        [self loadRequest];
    } else {
        
        [self downLoadFile];
    }
    
}

- (void)downLoadFile
{
    self.progressView.hidden = NO;
    [_model.fileContent getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        NSString *fileSavePath = [_model.objectId pathFromFileID];
        [data writeToFile:fileSavePath atomically:YES];
        
    } progressBlock:^(NSInteger percentDone) {
       
        _progressView.progress = percentDone / 100.0;
        
        if (percentDone == 100) {
            [_progressView removeFromSuperview];
            [self loadRequest];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTSFileDownLoadFinishNotification object:@(_row)];
        }
    }];
}

- (void)loadRequest
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *filePath = [self.model.objectId pathFromFileID];
//        NSLog(@"%@",filePath);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.webView loadRequest:request];
            
        });
    });
}

@end
