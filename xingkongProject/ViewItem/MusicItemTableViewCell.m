//
//  MusicItemTableViewCell.m
//  xingkongProject
//
//  Created by longhlb on 15/4/6.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "MusicItemTableViewCell.h"

@implementation MusicItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.starButton.hidden=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
