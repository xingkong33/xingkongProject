//
//  MusicLRCViewController.h
//  xingkongProject
//
//  Created by longhlb on 15/3/22.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicLRCViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *LRCText;
@property (weak, nonatomic) IBOutlet UIToolbar *controllerBar;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playPreviousBut;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playOrStopBut;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playNextBut;
@property (weak, nonatomic) IBOutlet UILabel *currenTime;
@property (weak, nonatomic) IBOutlet UILabel *totleTime;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UILabel *songName;

- (IBAction)TouchBack:(id)sender;
- (IBAction)TouchDown:(id)sender;
@property (weak, nonatomic) NSString *lrcURL;
@end
