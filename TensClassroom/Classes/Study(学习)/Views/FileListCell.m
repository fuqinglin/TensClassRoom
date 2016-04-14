//
//  FileListCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "FileListCell.h"
#import "FileModel.h"
#import "DownLoadProgressView.h"
#import "NSString+FilePath.h"
#import "TSAlertView.h"

@interface FileListCell ()
@property (weak, nonatomic) IBOutlet UILabel *fileTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *downLoadButton;
@property (weak, nonatomic) IBOutlet DownLoadProgressView *progressView;

@end

@implementation FileListCell

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinish:) name:kTSFileDownLoadFinishNotification object:nil];
}

- (void)setModel:(FileModel *)model
{
    _model = model;
    
    self.fileTitleLabel.text = model.fileName;
    self.dateLabel.text = model.createDate;
    
    if ([model.objectId hasFile]) {
        
        self.downLoadButton.selected = YES;
    }
}


- (IBAction)downloadButtonAction:(UIButton *)sender {
    
    if (!sender.selected) { // 下载
        
        _progressView.hidden = NO;
        [_model.fileContent getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            NSString *fileSavePath = [_model.objectId pathFromFileID];
            [data writeToFile:fileSavePath atomically:YES];
            
        } progressBlock:^(NSInteger percentDone) {
            
            self.progressView.progress = percentDone / 100.0;
            if (percentDone == 100) {
                
                self.downLoadButton.selected = YES;
                _progressView.hidden = YES;
            }
        }];
        
    } else { // 删除
        
        [TSAlertView showMessage:@"确定删除此文件？" handler:^{
           
            [_model.objectId deleteFileFromFileID];
            [_model.fileContent clearCachedFile];
            _progressView.hidden = YES;
            sender.selected = NO;
        }];
    }
}


#pragma mark - 更新按钮状态
- (void)downloadFinish:(NSNotification *)notification
{
    NSInteger row = [notification.object integerValue];
    
    if (row == self.row) {
        
        self.downLoadButton.selected = YES;
    }
}

@end
