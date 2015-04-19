//
//  MusicLRCViewController.m
//  xingkongProject
//
//  Created by longhlb on 15/3/22.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "MusicLRCViewController.h"
#import "MusicController.h"
@interface MusicLRCViewController ()
@property (nonatomic,strong)NSMutableArray *lrcArr;
@end

@implementation MusicLRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getChangePlayButImageNotification:) name:@"upPlayButImage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showisDownIngAlert:) name:@"isdowning" object:nil];
    self.playNextBut.action = @selector(selectNextAction:);
    self.playPreviousBut.action =@selector(selectPreviouAction:);
    self.playOrStopBut.action = @selector(selectStopOrPlayAction:);
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)getChangePlayButImageNotification:(id)sender
{
    if ([MusicController getInstance].isplayIng) {
       
        [self.playOrStopBut setStyle:UIBarButtonSystemItemPause];
        [self.playOrStopBut setImage:[UIImage imageNamed:@"暂停"]];
        
    }else
    {
        [self.playOrStopBut setImage:[UIImage imageNamed:@"播放"]];
    }
}
-(void)showisDownIngAlert:(id)sender
{
    if (self.view.window) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"加入失败" message:@"下载列表已经存在该曲目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil ];
        [alerView show];
    }
}
-(void)setLrcURL:(NSString *)lrcURL
{
    if (!_lrcURL) {
        _lrcURL = @"";
    }
    if (![_lrcURL isEqualToString:lrcURL]) {
        [self.LRCText setText:@"\n \n \n \n \n 歌词加载中"];
        self.LRCText.font = [UIFont systemFontOfSize:18.0f];
        self.LRCText.textColor=[UIColor blueColor];
        [self.LRCText setTextAlignment:NSTextAlignmentCenter];
        _lrcURL = lrcURL;
        [self.singerName setText:@" "];
        [self.songName setText:@" "];
        //百度外连
//        NSString *songLrcName = [lrcURL substringFromIndex:[lrcURL rangeOfString:@"=" options:NSBackwardsSearch].location];
        //新阿里云
        NSString *songLrcName = [lrcURL substringFromIndex:[lrcURL rangeOfString:@"/" options:NSBackwardsSearch].location];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *loadSongLrcString  ;
        @try {
            loadSongLrcString =[[NSString alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",docDir,songLrcName] encoding:NSUTF8StringEncoding error:nil];
        }
        @catch (NSException *exception) {
            [self loadLRCdata:lrcURL];
        }
        @finally {
            
        }
       
        if (loadSongLrcString) {
            [self lrcArrinfo:loadSongLrcString];
        }else
        {
            [self loadLRCdata:lrcURL];
        }
//        [loadstring writeToFile:[NSString stringWithFormat:@"%@/%@",docDir,saveSonglrcName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
//        [self loadLRCdata:lrcURL];
    }
    [self.ProgressBar setProgress:0.0f];
    
    __weak MusicLRCViewController *weakLrcController = self;
    MusicController *controller = [MusicController getInstance];
    controller.upProgress = ^(float *progress)
    {
        if (weakLrcController) {
            [weakLrcController.ProgressBar setProgress:*progress];
        }
    
    };
    controller.upLRC = ^(Float64 totTime,Float64 currentTime){
        NSInteger inttotTime = totTime;
        NSInteger m = inttotTime / 60;
        NSInteger s = inttotTime % 60;
        NSMutableString *timestring = [NSMutableString stringWithFormat:@""];
        if (m<10) {
            [timestring appendFormat:@"0"];
        }
        [timestring appendFormat:[NSString stringWithFormat:@"%ld",m]];
        [timestring appendFormat:@":"];
        if (s<10) {
            [timestring appendFormat:@"0"];
        }
            [timestring appendFormat:[NSString stringWithFormat:@"%ld",s]];
        
        weakLrcController.totleTime.text = timestring;
        
        inttotTime = currentTime;
        m = inttotTime / 60;
        s = inttotTime % 60;
        NSMutableString *currenTime = [NSMutableString stringWithFormat:@""];
        if (m<10) {
            [currenTime appendFormat:@"0"];
        }
        [currenTime appendFormat:[NSString stringWithFormat:@"%ld",m]];
        [currenTime appendFormat:@":"];
        if (s<10) {
            [currenTime appendFormat:@"0"];
        }
        [currenTime appendFormat:[NSString stringWithFormat:@"%ld",s]];
        
        weakLrcController.currenTime.text = currenTime;
        
        weakLrcController.totleTime.font = weakLrcController.currenTime.font = [UIFont systemFontOfSize:13.0f];
       weakLrcController.totleTime.textColor = weakLrcController.currenTime.textColor = [UIColor whiteColor];
        
         NSMutableString *tempString = [[NSMutableString alloc]initWithFormat: @"\n\n"];
        NSMutableDictionary *lrcObject;
        Float64 templrcTime;
        NSString *templrcString;
        for (NSInteger i = 0; i<[weakLrcController.lrcArr count]; i++) {
            lrcObject = [weakLrcController.lrcArr objectAtIndex:i];
            templrcTime = [(NSNumber *)[lrcObject objectForKey:@"time"]floatValue];
            if (templrcTime>inttotTime) {
                NSString *lateString =(NSString *)[lrcObject objectForKey:@"lrc"];

                if (i>1) {
                    lrcObject = [weakLrcController.lrcArr objectAtIndex:(i-1)];
                    templrcString = [lrcObject objectForKey:@"lrc"];
                    [tempString appendFormat:@"%@\n %@",templrcString,lateString];
                }else
                {
                    templrcString =lateString;
                }
                break;
            }
            
        }
        
        
        [weakLrcController.LRCText setText:tempString];
        weakLrcController.LRCText.font = [UIFont systemFontOfSize:18.0f];
        weakLrcController.LRCText.textColor=[UIColor whiteColor];
        [weakLrcController.LRCText setTextAlignment:NSTextAlignmentCenter];
        
        [weakLrcController.LRCText.textStorage addAttributes:@{ NSStrokeWidthAttributeName:@-2,NSStrokeColorAttributeName :[UIColor blackColor] } range: NSMakeRange(0,tempString.length)];
        
    };
}
-(void)lrcArrinfo:(NSString *)lrcData
{
    NSArray *tempArray = [lrcData componentsSeparatedByString:@"["];
    self.lrcArr = [[NSMutableArray alloc]init];
    NSMutableString *tempString = [[NSMutableString alloc]initWithFormat: @"\n\n"];
    for (id item in tempArray) {
        NSArray *tempitemArray = [item componentsSeparatedByString:@"]"];
        if ([tempitemArray count]>1){
            if ([(NSString *)tempitemArray[1] isEqualToString:@""])
            {
                NSArray *tiArr = [(NSString *)tempitemArray[0] componentsSeparatedByString:@":"];
                if ([(NSString *)tiArr[0] rangeOfString:@"ar"].length >0) {
                    [tempString appendString:@"歌手："];
                    [tempString appendString:tiArr[1]];
                    [tempString appendString:@"\n"];
                    
                    [self.singerName setText:tiArr[1]];
                }else if([(NSString *)tiArr[0] rangeOfString:@"ti"].length >0)
                {
                    [tempString appendString:@"歌名："];
                    [tempString appendString:tiArr[1]];
                    [tempString appendString:@"\n"];
                    
                    [self.songName setText:tiArr[1]];
                }
                NSLog(@"ti%@",tempitemArray[0]);
            }else
            {
                NSArray *tempTimeitemArr =[tempitemArray[0] componentsSeparatedByString:@":"];
                Float64 itemtimeline = 0;
                if ([tempTimeitemArr count]) {
                    itemtimeline+=[tempTimeitemArr[0] intValue]*60;
                    itemtimeline+=[tempTimeitemArr[1] intValue];
                }
                NSMutableDictionary *tempThetimeItem = [[NSMutableDictionary alloc]init];
                [tempThetimeItem setObject:[NSNumber numberWithFloat:itemtimeline] forKey:@"time"];
                [tempThetimeItem setObject:tempitemArray[1] forKey:@"lrc"];
                [ self.lrcArr addObject:tempThetimeItem];
            }
        }
    }
    [self.LRCText setText:tempString];
    self.LRCText.font = [UIFont systemFontOfSize:18.0f];
    self.LRCText.textColor=[UIColor whiteColor];
    [self.LRCText setTextAlignment:NSTextAlignmentCenter];
   
    [self.LRCText.textStorage addAttributes:@{ NSStrokeWidthAttributeName:@-2,NSStrokeColorAttributeName :[UIColor blackColor] } range: NSMakeRange(0,tempString.length)];
    
}
-(void)loadLRCdata:(NSString *)url
{
    __weak MusicLRCViewController *weakSelf = self;
    //百度外连
//    NSString *songLrcName = [url substringFromIndex:[url rangeOfString:@"=" options:NSBackwardsSearch].location];
    //阿里云
        NSString *songLrcName = [url substringFromIndex:[url rangeOfString:@"/" options:NSBackwardsSearch].location];
    __block NSString *saveSonglrcName = [songLrcName copy];
    NSURL *theLrcURL = [NSURL URLWithString:url];
    NSURLRequest *request=[NSURLRequest requestWithURL:theLrcURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:
                                      ^(NSURL *location, NSURLResponse *response, NSError *error)
                                      {
                                          if(!error)
                                          {
                                              if ([request.URL isEqual:theLrcURL]) {
                                                  NSString *loadstring = [[NSString alloc]initWithData:[NSData dataWithContentsOfURL:location] encoding:NSUTF8StringEncoding];
                                                  
                                                  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                  NSString *docDir = [paths objectAtIndex:0];
                                                  [loadstring writeToFile:[NSString stringWithFormat:@"%@/%@",docDir,saveSonglrcName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      if (weakSelf)
                                                      {
                                                          [weakSelf lrcArrinfo:loadstring];

                                                      }
                                                 });
                                              }
                                          }
                                      }];
    [task resume];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)TouchBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)TouchDown:(id)sender
{
    NSLog(@"准备下载");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dowmMusic" object:nil];
}
@end
