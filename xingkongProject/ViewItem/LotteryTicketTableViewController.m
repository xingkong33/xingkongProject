//
//  LotteryTicketTableViewController.m
//  xingkongProject
//
//  Created by longhlb on 15/4/14.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "LotteryTicketTableViewController.h"
#import "XingkongTool.h"
@interface LotteryTicketTableViewController ()
@property(nonatomic,strong)NSMutableArray *ssq;
@property(nonatomic,strong)UIActivityIndicatorView *activity;
@end

@implementation LotteryTicketTableViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       
        [self loadLotteryTicketData];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.ssq && ([self.ssq count]>1)) {
        NSLog(@"");
        [self visibleActivity];
        [self.tableView reloadData];
    }else
    {
        [self loadLotteryTicketData];
        [self showActivity];
    }
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

-(void)loadLotteryTicketData
{
    if (!_ssq) {
        _ssq = [[NSMutableArray alloc]init];
    }
    NSDictionary *josnDic=[XingkongTool loadJosn:@"http://f.opencai.net/utf-8/ssq-50.json"];
    for (id item in [josnDic objectForKey:@"data"]) {
        NSString *expect=[item objectForKey:@"expect"];
        NSString *opencode=[item objectForKey:@"opencode"];
        NSString *year=[expect substringToIndex:4];
        NSString *count=[expect substringFromIndex:4];
        NSArray *number=[opencode componentsSeparatedByString:@"+"];
        NSString *redBall=[number objectAtIndex:0];
        NSString *buleBall=[number objectAtIndex:1];
        //            NSString *tatle = [NSString stringWithFormat:@"双色球%@期开奖结果：%@ 蓝球 %@",count,redBall,buleBall];
        NSArray *total = [[NSArray alloc]initWithObjects:year,count,redBall,buleBall, nil];
        [_ssq addObject:total];
        NSLog(@"%@",[NSString stringWithFormat:@"双色球%@年%@期开奖结果：%@ 蓝球 %@",year,count,redBall,buleBall]);
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.ssq?[self.ssq count]:0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" ];
    if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
     NSArray *data = [_ssq objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@期%@红：%@",data[1],data[2],data[3]];
    return cell;
}


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
