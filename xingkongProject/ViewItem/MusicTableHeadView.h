//
//  MusicTableHeadView.h
//  xingkongProject
//
//  Created by longhlb on 15/4/9.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicTableHeadView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *playProgress;
@property (weak, nonatomic) IBOutlet UIButton *playOrStopBut;
@property (weak, nonatomic) IBOutlet UIButton *playPrevious;
@property (weak, nonatomic) IBOutlet UIButton *playNext;
@property (weak, nonatomic) IBOutlet UILabel *playNowTime;
@property (weak, nonatomic) IBOutlet UILabel *TotalTime;

@end
