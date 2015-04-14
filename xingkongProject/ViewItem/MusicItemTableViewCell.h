//
//  MusicItemTableViewCell.h
//  xingkongProject
//
//  Created by longhlb on 15/4/6.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@end
