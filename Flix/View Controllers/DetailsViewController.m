//
//  DetailsViewController.m
//  Flix
//
//  Created by Anna Kuznetsova on 6/24/20.
//  Copyright © 2020 Anna Kuznetsova. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieTrailerViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSString *fullYoutubeURLString;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropURLString;
    if(![self.movie[@"backdrop_path"] isEqual:[NSNull null]]){
        backdropURLString = self.movie[@"backdrop_path"];
    }
    else{
        backdropURLString = posterURLString;
    }
    
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    [self.backdropView setImageWithURL:backdropURL];
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.dateLabel sizeToFit];
    [self getMovieKey];
}

-(void)getMovieKey{
    
    NSString *startURL = @"https://api.themoviedb.org/3/movie/";
    NSString *movieID = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
    NSString *apiKey = @"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *fullURLString = [[startURL stringByAppendingString:movieID] stringByAppendingString:apiKey];
    
    NSURL *url = [NSURL URLWithString:fullURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSArray *result = dataDictionary[@"results"];
               if([result count] == 0)
               {
                   NSLog(@"empty");
                   self.fullYoutubeURLString = @"https://www.youtube.com";
               }else{
                   NSString *movieKey = result[0][@"key"];
                   NSString *urlStart = @"https://www.youtube.com/watch?v=";
                   self.fullYoutubeURLString = [urlStart stringByAppendingString:movieKey];
               }
               
        }
       }];
    [task resume];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    MovieTrailerViewController *movieTrailerViewController = [segue destinationViewController];
    movieTrailerViewController.youTubeString = self.fullYoutubeURLString;
}


@end
