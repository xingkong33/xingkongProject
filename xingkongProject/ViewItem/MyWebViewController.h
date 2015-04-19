//
//  MyWebViewController.h
//  xingkongProject
//
//  Created by longhlb on 15/4/19.
//  Copyright (c) 2015年 longhlb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)restWebView:(id)sender;

- (IBAction)goForward:(id)sender;
- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *webURLInpurt;

@end
