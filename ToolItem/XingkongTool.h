//
//  XingkongTool.h
//  xingkongProject
//
//  Created by longhlb on 15/3/19.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XingkongTool : NSObject
+(NSDictionary *)loadJosn:(NSString *)url;
+(void)loadJosn:(NSString *)url callBack:(void (^)(NSDictionary *dataDic))inBlock;

@end
