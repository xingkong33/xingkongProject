//
//  MusicTableViewController.m
//  xingkongProject
//
//  Created by longhlb on 15/3/21.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "MusicTableViewController.h"
#import "XingkongTool.h"
#import "musicItemDate.h"
#import "MusicController.h"
#import "MusicLRCViewController.h"
#import "MusicItemTableViewCell.h"
#import "MusicTableHeadView.h"
@interface MusicTableViewController ()
@property UIActivityIndicatorView *activity;
@property NSDictionary *songListdata;
@property NSMutableArray *songlist;
@property MusicController *playController;
@property MusicLRCViewController *LRCController;
@property MusicTableHeadView *HeadView;
@end

@implementation MusicTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        
        [self.tableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]]];
        NSArray *libViewArray = [[NSBundle mainBundle]loadNibNamed:@"MusicTableHeadView" owner:nil options:nil];
        self.HeadView = [libViewArray lastObject];
        self.HeadView.frame = CGRectMake(0, 130, self.view.frame.size.width, 103);
        self.HeadView.songNameLabel.text = @"";
        [self.HeadView.playProgress setProgress:0];
        self.tableView.tableHeaderView = self.HeadView;
    }
    return self;
}
-(void)upHeadProgress:(NSNumber *)progress
{
    if (self.HeadView) {
        [self.HeadView.playProgress setProgress:[progress floatValue]];
    }

}
-(void)upHeadRLCTime:(NSNumber *)totleTime currenTime:(NSNumber *)currentTime
{
    if (self.HeadView) {
        if (totleTime<0) {
            totleTime=0;
        }
        if (currentTime<0) {
            currentTime=0;
        }
        NSInteger m = ([totleTime floatValue] / 60);
        NSInteger s = ([totleTime integerValue] % 60);
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
        
       self.HeadView.TotalTime.text = timestring;
        
        m = [currentTime floatValue] / 60;
        s = [currentTime integerValue] % 60;
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
        
        self.HeadView.playNowTime.text = currenTime;
    }

}
-(void)awakeFromNib
{
    NSLog(@"nib load complete");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
          if (!self.songListdata) {
        [self showActivity];
        [self loadSongListData];
    }else
    {
        if (!self.songlist) {
            
             [self songListInfo];
        }
        if ([self.songlist count])
        {
            //百度外连
            if (!self.playController)
            {
                self.playController = [MusicController getInstance];
                [self.playController setSongData:self.songlist];
//                [self.playController play:0];
                
                [self.tableView reloadData];
                NSInteger *index = 0;
                [self changeHeadViewData:index];
                self.playController.delegate = self;
                self.playController.upLRCSEL = @selector(upHeadRLCTime:currenTime:);
                self.playController.upProgressSel=@selector(upHeadProgress:);
                
                NSUInteger temp[2] = {0,5};
                NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:temp length:2];
                [self.tableView scrollToRowAtIndexPath: indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPlayNextNotification:) name:@"touchPlayNextSong" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPlayProeviouNotification:) name:@"touchPreviouSong" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPlayOrStopNotification:) name:@"playOrStopSong" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getPlayNextNotification:) name:@"MusicPlayComplete" object:nil];

}
-(void)getPlayNextNotification:(id)sender
{
    if (self.playController) {
        [self.playController playNext];
        musicItemDate *item = [self.songlist objectAtIndex:(NSUInteger)self.playController.playIngIndex];
        [self changeHeadViewData:self.playController.playIngIndex];
        self.LRCController.lrcURL= item.musicLRY;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSData *tempImageData = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg",docDir,item.musicName]];
        if (tempImageData) {
            self.LRCController.bgImageView.image = [UIImage imageWithData:tempImageData];
        }else{
            
            self.LRCController.bgImageView.image = [UIImage imageNamed:@"背景"];
            [self loadImage:self.LRCController.bgImageView loadUrl:item.singerImageUrl saveTofild:[NSString stringWithFormat:@"/%@.jpg",item.musicName]];
        }

    }
}
-(void)getPlayProeviouNotification:(id)sender
{
    if (self.playController) {
        [self.playController playPrevious];
        musicItemDate *item = [self.songlist objectAtIndex:(NSUInteger)self.playController.playIngIndex];
        [self changeHeadViewData:self.playController.playIngIndex];
        self.LRCController.lrcURL= item.musicLRY;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSData *tempImageData = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg",docDir,item.musicName]];
        if (tempImageData) {
            self.LRCController.bgImageView.image = [UIImage imageWithData:tempImageData];
        }else{
            
            self.LRCController.bgImageView.image = [UIImage imageNamed:@"背景"];
            [self loadImage:self.LRCController.bgImageView loadUrl:item.singerImageUrl saveTofild:[NSString stringWithFormat:@"/%@.jpg",item.musicName]];
        }

    }
}
-(void)getPlayOrStopNotification:(id)sender
{
    if (self.playController) {
        [self.playController pause];
    }

}
-(void)songListInfo
{
    if (!self.songlist) {
        self.songlist = [[NSMutableArray alloc]init];
        musicItemDate *musicItem;
        
            for (id item in [self.songListdata objectForKey:@"data"]) {
                musicItem = [[musicItemDate alloc] init];
                musicItem.musicName = [item objectForKey:@"name"];
                musicItem.musicURL = [item objectForKey:@"musicURL"];
                musicItem.musicLRY = [item objectForKey:@"lyrURL"];
                musicItem.singerImageUrl = [item objectForKey:@"singerImage"];
                musicItem.headImageUrl = [item objectForKey:@"headImage"];
                [self.songlist addObject:musicItem];
            }
    }
    //阿里运
    if (!self.playController)
    {
        self.playController = [MusicController getInstance];
        [self.playController setSongData:self.songlist];
        //                [self.playController play:0];
        
        [self.tableView reloadData];
        NSInteger *index = 0;
        [self changeHeadViewData:index];
        self.playController.delegate = self;
        self.playController.upLRCSEL = @selector(upHeadRLCTime:currenTime:);
        self.playController.upProgressSel=@selector(upHeadProgress:);
        
        NSUInteger temp[2] = {0,5};
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:temp length:2];
        [self.tableView scrollToRowAtIndexPath: indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}
-(void)loadSongListData
{
    __weak MusicTableViewController *weakSelf = self;
    void (^data)(NSDictionary *)= ^(NSDictionary *dic)
    {
        weakSelf.songListdata = dic;
        [weakSelf songListInfo];
        [weakSelf visibleActivity];

        if (weakSelf.view.window) {
            dispatch_sync(dispatch_get_main_queue(), ^(){
                
            [weakSelf viewDidLoad];});
        }
        
        
    };
//    [XingkongTool loadJosn:@"http://pan.plyz.net/d.asp?u=2214919116&p=music.txt " callBack:data];
    //    NSLog(@"%@",self.Weatherdata);
    [XingkongTool loadJosnForCloud:@"/music.txt" callBack:data];
}
-(void)showActivity
{
    if (!self.activity)
    {
        self.activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.activity setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    if (self.view)
    {
        [self.view addSubview:self.activity];
        self.activity.hidden=NO;
        [self.activity startAnimating];
        [super viewDidLoad];
    }
}
-(void)visibleActivity
{
    if (self.activity)
    {
        [self.activity stopAnimating];
        [self.activity removeFromSuperview];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSMutableArray *myToolBarItems = [NSMutableArray array];
    [myToolBarItems addObject:[[UIBarButtonItem alloc]initWithTitle:@"one" style:UIBarButtonItemStylePlain
                                                             target:self action:@selector(action)]];
    [self.navigationController.toolbar setItems:myToolBarItems];
    self.navigationController.toolbarHidden = NO;
}

-(void)changeHeadViewData:(NSInteger *)index
{
    musicItemDate *musicItem = [self.songlist objectAtIndex:index ];
    [self.HeadView.songNameLabel setText:musicItem.musicName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSData *tempImageData = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.headimg",docDir,musicItem.musicName]];
    if (tempImageData) {
        self.HeadView.headImage.image =[UIImage imageWithData:tempImageData];
    }else{
        [self loadImage:self.HeadView.headImage loadUrl:musicItem.headImageUrl saveTofild:[NSString stringWithFormat:@"/%@.headimg",musicItem.musicName]];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                               
-(void)action
{
    NSLog(@"%@",@"touch");
}
-(void)getdownMusicNotifcation:(id)sender
{
    NSLog(@"get notifcation to down mp3");
    musicItemDate *item = [self.songlist objectAtIndex:self.playController.playIngIndex];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *saveUrl = [NSString stringWithFormat:@"%@/%@",docDir,item.musicName];
    NSData *tempData = [[NSData alloc]initWithContentsOfFile:saveUrl ];
    if (!tempData) {
        __weak MusicTableViewController *weakSelf = self;
        [XingkongTool downDataForASY:item.musicURL saveto:item.musicName completeBack:^(BOOL *noErr,NSData *downData)
        {
            NSString *messageString;
             if (noErr) {
                //[NSString stringWithFormat:docDir,@"/",@"qiyou.mp3"];
                
                 NSLog(@"下载完成");
                messageString = @"下载完成";
            }else
            {
                NSLog(@"下载失败");
                messageString = @"下载失败 请重试";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载结束" message:messageString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
             if (weakSelf)
             {
                if (weakSelf.view.window) {
                    [weakSelf.view addSubview:alertView];
                }else if(weakSelf.LRCController.view.window)
                {
                    [weakSelf.LRCController.view addSubview:alertView];
                   
                }
                    [alertView show];
             }
            });/**/
        }];

    }else
    {
        NSLog(@"你已下载过");
         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载结束" message:@"你已下载过" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        
        if (self.view.window) {
            [self.view addSubview:alertView];
        }else if(self.LRCController.view.window)
        {
            [self.LRCController.view addSubview:alertView];
        }
         [alertView show];
    }
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *cellDentifierString = @"MusicItemTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDentifierString];
    NSInteger temp = [indexPath row];
    musicItemDate *musicItem = (musicItemDate *) [self.songlist objectAtIndex:temp];
    MusicItemTableViewCell *itemcell;
   if (!cell)
   {
       NSArray *libViewArray = [[NSBundle mainBundle]loadNibNamed:cellDentifierString owner:nil options:nil];
        itemcell = libViewArray[0];
       itemcell.backgroundColor = [UIColor clearColor];
   }else
   {
       itemcell = (MusicItemTableViewCell *)cell;
   }
    [itemcell.songNameLabel setText:[[NSString alloc]initWithFormat:@"%@", musicItem.musicName]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSData *tempImageData = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.headimg",docDir,musicItem.musicName]];
    if (tempImageData) {
        itemcell.headImage.image =[UIImage imageWithData:tempImageData];
    }else{
    [self loadImage:itemcell.headImage loadUrl:musicItem.headImageUrl saveTofild:[NSString stringWithFormat:@"/%@.headimg",musicItem.musicName]];
    }
    cell = itemcell;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger temp = [indexPath row];
    if (!self.LRCController) {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.LRCController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MusicLrcViewController"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getdownMusicNotifcation:) name:@"dowmMusic" object:nil];
        
        [self.playController play:temp];
        [self changeHeadViewData:temp];
        
    }else
    {
        if (self.playController.playIngIndex == temp) {
            [self presentViewController:self.LRCController animated:YES completion:^{}];
            return;
        }else
        {
            [self.playController play:temp];
            [self changeHeadViewData:temp];
        }
    }
    [ self presentViewController: self.LRCController animated:YES completion:^()
     {
         musicItemDate *item = [self.songlist objectAtIndex:temp];
         self.LRCController.lrcURL= item.musicLRY;
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *docDir = [paths objectAtIndex:0];
         NSData *tempImageData = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.jpg",docDir,item.musicName]];
         if (tempImageData) {
             self.LRCController.bgImageView.image = [UIImage imageWithData:tempImageData];
         }else{
         
             self.LRCController.bgImageView.image = [UIImage imageNamed:@"背景"];
             [self loadImage:self.LRCController.bgImageView loadUrl:item.singerImageUrl saveTofild:[NSString stringWithFormat:@"/%@.jpg",item.musicName]];
         }
         
         
     }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.songlist?[self.songlist count]:0;
    //    return [[[BNRItemStore sharedStore]allItems]count];
}


-(void )loadImage:(UIImageView *)imageView loadUrl:(NSString *)url saveTofild:(NSString *)fildUrl
{
    NSURL *imageURL =[NSURL URLWithString:url];
    NSURLRequest *request=[NSURLRequest requestWithURL:imageURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:
                                      ^(NSURL *location, NSURLResponse *response, NSError *error)
                                      {
                                          if(!error)
                                          {
                                              if ([request.URL isEqual:imageURL]) {
                                                  NSData *loadData = [NSData dataWithContentsOfURL:location];
                                                  UIImage *image = [UIImage imageWithData:loadData];
                                                  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                  NSString *docDir = [paths objectAtIndex:0];
                                                  [loadData writeToFile:[NSString stringWithFormat:@"%@%@",docDir,fildUrl] atomically:YES];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      imageView.image = image;
                                                  });
                                              }
                                          }
                                      }];
    [task resume];
    
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
