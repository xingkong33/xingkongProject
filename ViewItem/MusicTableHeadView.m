//
//  MusicTableHeadView.m
//  xingkongProject
//
//  Created by longhlb on 15/4/9.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "MusicTableHeadView.h"
#import "MusicController.h"
@implementation MusicTableHeadView
+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}
-(void)awakeFromNib
{
    [self.playNext addTarget:self action:@selector(selectNextAction:) forControlEvents:UIControlEventTouchDown];
    [self.playPrevious addTarget:self action:@selector(selectPreviouAction:) forControlEvents:UIControlEventTouchDown];
    [self.playOrStopBut addTarget:self action:@selector(selectStopOrPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getChangePlayButImageNotification:) name:@"upPlayButImage" object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)getChangePlayButImageNotification:(id)sender
{
    if ([MusicController getInstance].isplayIng) {

        [self.playOrStopBut setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }else
    {
        [self.playOrStopBut setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];

    }
    [super drawRect:self.frame];
}
-(void)selectNextAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"touchPlayNextSong" object:nil];
}
-(void)selectPreviouAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"touchPreviouSong" object:nil];
}
-(void)selectStopOrPlayAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playOrStopSong" object:@"Yes"];
    
}

@end
