//
//  MovieTrailerViewController.m
//  Flix
//
//  Created by Anna Kuznetsova on 6/26/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "MovieTrailerViewController.h"
#import <WebKit/WebKit.h>

@interface MovieTrailerViewController ()

@property (strong, nonatomic) IBOutlet WKWebView *trailerWebView;

@end

@implementation MovieTrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *youtubeLink = [NSURL URLWithString:self.youTubeString];
    NSURLRequest *youtubeRequest = [NSURLRequest requestWithURL:youtubeLink];
    [self.trailerWebView loadRequest:youtubeRequest];
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
