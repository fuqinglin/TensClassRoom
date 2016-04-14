//
//  VideoItemCell.m
//  TensClassroom
//
//  Created by qinglinfu on 16/3/25.
//  Copyright © 2016年 十安科技. All rights reserved.
//

#import "VideoItemCell.h"
#import "VideoModel.h"

@interface VideoItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;

@end

@implementation VideoItemCell


- (void)setModel:(VideoModel *)model
{
    _model = model;
    
    self.videoTitleLabel.text = model.videoTitle;
    [_model.videoImage getThumbnail:NO width:200 height:150 withBlock:^(UIImage *image, NSError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.videoBgImageView.image = image;
        });
    }];
    
}



@end
