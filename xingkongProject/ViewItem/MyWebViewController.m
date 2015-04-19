//
//  MyWebViewController.m
//  xingkongProject
//
//  Created by longhlb on 15/4/19.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "MyWebViewController.h"

@interface MyWebViewController ()

@property UIActivityIndicatorView *activity;


@end

@implementation MyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView setDelegate:self];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://i.u148.net"]];
    [self.webView loadRequest:req];
}
-(void)goBack:(id)sender
{
    [self.webView goBack];
}
- (IBAction)restWebView:(id)sender {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURLInpurt.text]]];
}

-(void)goForward:(id)sender
{
    [self.webView goForward];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [self showActivity];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webURLInpurt.text = webView.request.URL.absoluteString;
    [self visibleActivity];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"加载出错" message:@"连接失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alertView show];
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
