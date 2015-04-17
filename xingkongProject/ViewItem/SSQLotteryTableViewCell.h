//
//  SSQLotteryTableViewCell.h
//  xingkongProject
//
//  Created by longhlb on 15/4/16.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSQLotteryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *redBallLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueBallOne;
@property (weak, nonatomic) IBOutlet UILabel *blueBallTwo;
@property (weak, nonatomic) IBOutlet UILabel *blueBallThree;
@property (weak, nonatomic) IBOutlet UILabel *blueBallFour;
@property (weak, nonatomic) IBOutlet UILabel *blueBallFive;
@property (weak, nonatomic) IBOutlet UILabel *blueBallsix;

@end
