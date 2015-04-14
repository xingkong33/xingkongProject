//
//  XingkongTool.m
//  xingkongProject
//
//  Created by longhlb on 15/3/19.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import "XingkongTool.h"

@implementation XingkongTool
+(NSDictionary *)loadJosn:(NSString *)url
{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"%@",error);
        NSString *requestString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        requestString = [requestString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        response = [requestString dataUsingEncoding:NSUTF8StringEncoding];
        weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    }
    return weatherDic;

}
+(void)loadJosn:(NSString *)url callBack:(void (^)(NSDictionary *))inBlock
{
    dispatch_queue_t theQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(theQueue, ^{
        NSError *error;
        //加载一个NSURL对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"%@",error);
            NSString *requestString = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
            requestString = [requestString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            requestString = [requestString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            requestString = [requestString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            response = [requestString dataUsingEncoding:NSUTF8StringEncoding];
            weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        }
        inBlock(weatherDic);
    
    
        ;});
}
@end
