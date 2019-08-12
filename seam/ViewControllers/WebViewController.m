//
//  WebViewController.m
//  seam
//
//  Created by festusojo on 8/9/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WKWebViewConfiguration.h>
#import "MatchesViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    NSLog(@"url here, %@", _jobURL);
    NSURL *nsurl= [NSURL URLWithString:_jobURL];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
}

@end
