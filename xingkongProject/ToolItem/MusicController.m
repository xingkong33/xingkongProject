//
//  MusicController.m
//  xingkongProject
//
//  Created by longhlb on 15/3/21.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "MusicController.h"
#import <AVFoundation/AVFoundation.h>
#import "musicItemDate.h"
@interface MusicController ()<AVAudioPlayerDelegate>
@property(nonatomic,strong)AVPlayer *onLinePlay;
@property(nonatomic,strong)AVAudioPlayer *localPlay;
@property(nonatomic,strong)NSMutableArray *songListArr;
@property(nonatomic,strong)musicItemDate *saveItem;



#pragma mark 点按扭会响应两次，来个开关修改下先
@property(nonatomic)NSInteger *debugValue;

@property(nonatomic,strong)NSTimer *timer;
@end
@implementation MusicController
+(MusicController *)getInstance
{
    static MusicController *Instance;
    if (!Instance) {
        Instance = [self alloc];
        [[NSNotificationCenter defaultCenter]addObserver:Instance selector:@selector(playComplete:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
   
    return Instance;
}
-(void)setSongData:(NSMutableArray *)DataArr
{
    self.songListArr = DataArr;
}
-(void)play:(NSInteger *)index
{
    self.playIngIndex = index;
    musicItemDate *item = [self.songListArr objectAtIndex:(NSUInteger)index];
    if (self.saveItem)
    {
        if (self.localPlay) {
            [self.localPlay stop];
            self.localPlay = nil;
        }else
        {
            if (self.onLinePlay) {
                [self.onLinePlay pause];
                self.onLinePlay = nil;
            }
            
        }
    }
    if (item) {
        
        NSURL *songUrl = [NSURL  URLWithString:[NSString stringWithFormat:@"%@",[item musicURL]]];
        NSData *dowmMp3 ;
        NSError *error = nil;
        @try {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            dowmMp3 = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",docDir,item.musicName]];
          // dowmMp3 = [NSData dataWithContentsOfURL:songUrl];
        }
        @catch (NSException *exception) {
            NSLog(@" not data %@",exception);
        }
        @finally {
            NSLog(@"in finally");
        }
        if (dowmMp3) {
            self.localPlay =[[AVAudioPlayer alloc]initWithData:dowmMp3 error:nil];
            self.localPlay.delegate = self;
            [self.localPlay prepareToPlay];
            [self.localPlay play];
             _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upPlayPercentageSelector:) userInfo:nil repeats:YES];
        }else
        {
            self.onLinePlay = [[ AVPlayer alloc]initWithURL:songUrl];
            [self.onLinePlay play];
            if (!error) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upPlayPercentageSelector:) userInfo:nil repeats:YES];
            }
        }
        self.saveItem = item;
        self.isplayIng = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"upPlayButImage" object:nil];
    }
}
-(void)playComplete:(id)sender
{
    NSLog(@"playComplete");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"MusicPlayComplete" object:nil];
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playComplete:nil];
    [_timer invalidate];
}
-(void)upPlayPercentageSelector:(NSTimer *)theTimer
{
    __block float percentage = 0.0f;
    if (self.onLinePlay) {
        percentage = (CMTimeGetSeconds(self.onLinePlay.currentItem.currentTime)/CMTimeGetSeconds(self.onLinePlay.currentItem.duration));
        if (percentage >=1.0f) {
            
            [_timer invalidate];
            
        }
        if (self.upProgress) {
            self.upProgress(&percentage);
        }
        if (self.delegate) {
            NSNumber *tempPrecentage = [NSNumber numberWithFloat:percentage];
            [_delegate performSelector:_upProgressSel withObject:tempPrecentage];
        }
        if (self.upLRC) {
            self.upLRC(CMTimeGetSeconds(self.onLinePlay.currentItem.duration),CMTimeGetSeconds(self.onLinePlay.currentItem.currentTime));
        }
        if (self.delegate) {
            NSNumber *duration = [NSNumber numberWithFloat:CMTimeGetSeconds(self.onLinePlay.currentItem.duration)];
            NSNumber *currentTime = [NSNumber numberWithFloat:CMTimeGetSeconds(self.onLinePlay.currentItem.currentTime)];
            [_delegate performSelector:_upLRCSEL withObject:duration withObject:currentTime];
        }
    }
    if (self.localPlay) {
        percentage = (self.localPlay.currentTime/self.localPlay.duration);
        if (percentage>=1.0f) {
            [_timer invalidate];
            [self playComplete:nil];
        }else
        {
            if (self.upProgress) {
                self.upProgress(&percentage);
            }
            if (self.delegate) {
                NSNumber *tempPrecentage = [NSNumber numberWithFloat:percentage];
                [_delegate performSelector:_upProgressSel withObject:tempPrecentage];
            }

            if (self.upLRC) {
                self.upLRC(self.localPlay.duration,self.localPlay.currentTime);
            }
            if (self.delegate) {
                NSNumber *duration = [NSNumber numberWithFloat:self.localPlay.duration];
                NSNumber *currentTime = [NSNumber numberWithFloat:self.localPlay.currentTime];
                [_delegate performSelector:_upLRCSEL withObject:duration withObject:currentTime];
            }

        }
        
    }
}
-(void)pause
{
    if (self.debugValue)
    {
        if (self.isplayIng)
        {
            if (self.localPlay)
            {
                [self.localPlay pause];
            }else
            {
                if (self.onLinePlay)
                {
                    [self.onLinePlay pause];
                }
                
            }
            self.isplayIng = NO;
        }else
        {
            if (self.localPlay)
            {
                [self.localPlay play];
            }else if (self.onLinePlay)
            {
                [self.onLinePlay play];
            }else
            {
                [self play:self.playIngIndex?self.playIngIndex:0];
            }
            self.isplayIng = YES;
            
        }

        [[NSNotificationCenter defaultCenter]postNotificationName:@"upPlayButImage" object:nil];
        self.debugValue = 0;
    }else
    {
        self.debugValue = 1;
    }
    
}
-(void)stop
{
    if (self.debugValue) {
        if (self.localPlay)
        {
            [self.localPlay stop];
        }else
        {
            if (self.onLinePlay) {
                [self.onLinePlay pause];
                self.onLinePlay = nil;
            }
        }
        self.debugValue = 0;
    }else
    {
        self.debugValue = 1;
    }

}
-(void)playForPercentage:(NSNumber *)Percentage
{

}
-(void)playNext
{
    if (self.debugValue) {
        NSInteger *tempIndex = (int)(self.playIngIndex+1+[self.songListArr count])%(int)[self.songListArr count];
        [self play:tempIndex];
        self.debugValue=0;
    }else
    {
        self.debugValue = 1;
    }
    
}
-(void)playPrevious
{
    if (self.debugValue) {
        NSInteger *tempIndex = (int)(self.playIngIndex-1+[self.songListArr count])%(int)[self.songListArr count];
        [self play:tempIndex];
        self.debugValue = 0;
    }else
    {
        self.debugValue = 1;
    }
   
}
-(void)dowm:(NSInteger *)index
{

}
@end
