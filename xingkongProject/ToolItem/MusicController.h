//
//  MusicController.h
//  xingkongProject
//
//  Created by longhlb on 15/3/21.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicController : NSObject
+(MusicController *)getInstance;
@property(nonatomic,strong)void(^upLRC)(Float64 totTime,Float64 currentTime);
@property(nonatomic,strong)void(^upProgress)(float *progress);
@property(nonatomic,strong)void(^dowmComplete)(NSInteger *index,NSURL *saveUrl,NSString *songName,NSNumber *Data);
-(void)setSongData:(NSMutableArray *)DataArr;
-(void)play:(NSInteger *)index;
-(void)playForPercentage:(NSNumber *)Percentage;
-(void)pause;
-(void)stop;
-(void)dowm:(NSInteger *)index;
-(void)playNext;
-(void)playPrevious;
@property(nonatomic)BOOL *isplayIng;
@property(nonatomic)NSInteger *playIngIndex;

@property(nonatomic,retain)id delegate;
@property(nonatomic,assign)SEL upLRCSEL ;
@property(nonatomic,assign)SEL upProgressSel;
@end
