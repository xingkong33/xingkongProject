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
+(void)downDataForASY:(NSString *)url saveto:(NSString *)savePath completeBack:(void (^)(BOOL *, NSData *))callBack
{
    static NSMutableDictionary *MydowmTask;
    static dispatch_queue_t dowm_t;
    static const char *dowm_t_char = "dowm_Nsdata";
    static const NSString *down_read = @"read down";
    static const NSString *down_downIng = @"downing";
    static const NSString *down_complete = @"down complete";
    if (!MydowmTask) {
        MydowmTask = [[NSMutableDictionary alloc]init];
    }
    if (!dowm_t) {
        dowm_t = dispatch_queue_create(dowm_t_char, NULL);
       
    }
    if (![MydowmTask objectForKey:url]) {
        [ MydowmTask setObject:[[NSMutableArray alloc]initWithObjects:down_read,savePath,callBack, nil]  forKey:url];
    }else
    {
        NSMutableArray *tempArr= [MydowmTask objectForKey:url];
        if ([down_complete isEqualToString: tempArr[0]]) {
            NSData *downData;
            callBack(YES,downData);
            return;
        } else //if(callBack!=tempArr[2])
        {
            NSLog(@"正在下载，把新的callback 加入到数组？");
            tempArr[2] = callBack;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"isdowning" object:nil];
            return;
        }
    }
     dispatch_async(dowm_t, ^{
         NSMutableArray *tempArr = [MydowmTask objectForKey:url];
        
         tempArr[0] = down_downIng;
          NSURL *downUrl = [NSURL URLWithString:url];
         NSURLRequest *request=[NSURLRequest requestWithURL:downUrl];
         NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
         NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
         NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:
                                           ^(NSURL *location, NSURLResponse *response, NSError *error)
                                           {
                                               
                                               if(!error)
                                               {
                                                   if ([request.URL isEqual:downUrl])
                                                   {
                                                       
                                                       NSData *downData = [NSData dataWithContentsOfURL:location];
                                                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                       NSString *docDir = [paths objectAtIndex:0];
                                                       [downData writeToFile:[NSString stringWithFormat:@"%@/%@",docDir,tempArr[1]] atomically:YES];
                                                       
                                                       tempArr[0] = down_complete;
                                                       
                                                       void (^ tempBack)(BOOL *bl,NSData *data) = tempArr[2];
                                                       tempBack(YES,downData);

                                                   }else
                                                   {
                                                       void (^ tempBack)(BOOL *bl,NSData *data) = tempArr[2];
                                                       tempBack(NO,[[NSData alloc]init]);
                                                   }
                                               }
                                               }];
         [task resume];
         
     });
}
@end
