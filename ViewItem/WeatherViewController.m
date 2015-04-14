//
//  WeatherViewController.m
//  xingkongProject
//
//  Created by longhlb on 15/3/18.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "WeatherViewController.h"
#import "XingkongTool.h"
@interface WeatherViewController ()
@property UIActivityIndicatorView *activity;
@property NSDictionary *Weatherdata;

@property UIImageView *bgImage;
@property UIImageView *weather_icon;
@property(nonatomic,strong)UIImageView *image;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.Weatherdata)
    {
        [self showActivity];
        [self loadWeatherData];
    }else
    {
        NSLog(@"%@",self.Weatherdata);
        [self showWeatherData];
    }
   
}
-(void)showWeatherData
{
    CGFloat countrHeight = 0;
    NSMutableArray *labelArray = [[NSMutableArray alloc]init];
    //    NSString *imageUrl;
    for (id item in [self.Weatherdata objectForKey:@"result"])
    {
        if (!self.bgImage) {
            NSString *theWeather = [NSString stringWithFormat:@"%@",[item objectForKey:@"weather"]];
            NSString *weatherIcon = [NSString stringWithFormat:@"%@",[item objectForKey:@"weather"]];
            NSRange foundobj = [theWeather rangeOfString:@"雷" options:NSCaseInsensitiveSearch];
            if (foundobj.length>0) {
                theWeather = [NSString stringWithFormat:@"雷雨背景"];
                weatherIcon = [NSString stringWithFormat:@"雷阵雨"];
            }else
            {
                foundobj = [theWeather rangeOfString:@"雨" options:NSCaseInsensitiveSearch];
                if (foundobj.length>0) {
                    foundobj = [theWeather rangeOfString:@"小雨" options:NSCaseInsensitiveSearch];
                    if (foundobj.length>0) {
                        weatherIcon = [NSString stringWithFormat:@"小雨"];
                    }else
                    {
                        foundobj = [theWeather rangeOfString:@"阵雨"];
                        if (foundobj.length>0) {
                            weatherIcon = [NSString stringWithFormat:@"阵雨"];
                        }else
                        {
                            foundobj = [theWeather rangeOfString:@"中雨" options:NSCaseInsensitiveSearch];
                            if (foundobj.length>0) {
                                weatherIcon = [NSString stringWithFormat:@"中雨"];
                            }else
                            {
                                foundobj = [theWeather rangeOfString:@"大雨" options:NSCaseInsensitiveSearch];
                                if (foundobj.length>0) {
                                    weatherIcon = [NSString stringWithFormat:@"大雨"];
                                }else
                                {
                                    foundobj = [theWeather rangeOfString:@"暴雨" options:NSCaseInsensitiveSearch];
                                    if (foundobj.length>0) {
                                        weatherIcon = [NSString stringWithFormat:@"暴雨"];
                                    }
                                }
                            }
                        }
                    }
                    theWeather = [NSString stringWithFormat:@"雨天背景"];
                }else
                {
                    foundobj = [theWeather rangeOfString:@"阴" options:NSCaseInsensitiveSearch];
                    if (foundobj.length>0) {
                        theWeather = [NSString stringWithFormat:@"阴天背景" ];
                        weatherIcon = [NSString stringWithFormat:@"阴天"];
                    }else
                    {
                        foundobj = [theWeather rangeOfString:@"多云"];
                        if (foundobj.length>0) {
                            theWeather = [NSString stringWithFormat:@"多云背景"];
                            weatherIcon = [NSString stringWithFormat:@"多云"];
                        }else
                        {
                            foundobj = [theWeather rangeOfString:@"雾" options:NSCaseInsensitiveSearch];
                            if (foundobj.length>0) {
                                theWeather = [NSString stringWithFormat:@"多云背景"];
                                weatherIcon = [NSString stringWithFormat:@"雾"];
                            }else
                            {
                                theWeather = [NSString stringWithFormat:@"晴天背景"];
                                weatherIcon = [NSString stringWithFormat:@"晴天"];
                            }
                        }
                    }
                }
            }
            self.bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:theWeather]];
            self.weather_icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:weatherIcon]];
            [self.bgImage setFrame:CGRectMake(0, 40, self.bgImage.frame.size.width, self.bgImage.frame.size.height)];
            [self.weather_icon setFrame:CGRectMake(110, 90, self.weather_icon.frame.size.width, self.weather_icon.frame.size.height )];
            countrHeight+=203;
            [self.view addSubview:self.bgImage];
            [self.view addSubview:self.weather_icon];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, countrHeight,self.view.frame.size.width, 50)];
        countrHeight+=50;
        [label setText:[NSString stringWithFormat:@" %@%@%@天气%@ , %@", [item objectForKey:@"days"],[item objectForKey:@"week"],[item objectForKey:@"citynm"],[item objectForKey:@"weather"],[item objectForKey:@"winp"]]];
        [self.view addSubview:label];
        [labelArray addObject:label];
        NSLog(@"%@", item);
    }
    //    [self loadWeatherImage:[NSURL URLWithString: imageUrl]];
    [self.image setFrame:CGRectMake(10, countrHeight, self.image.frame.size.width, self.image.frame.size.height)];
    [self.view addSubview:self.image];


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

-(void)loadWeatherData
{
    __weak WeatherViewController *weakSelf = self;
    void (^data)(NSDictionary *)= ^(NSDictionary *dic)
    {
        weakSelf.Weatherdata = dic;
        dispatch_sync(dispatch_get_main_queue(), ^(){
            [weakSelf visibleActivity];
            [weakSelf viewDidLoad];});
        
    };
    [XingkongTool loadJosn:@"http://api.k780.com:88/?app=weather.future&weaid=165&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json" callBack:data];
//    NSLog(@"%@",self.Weatherdata);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
