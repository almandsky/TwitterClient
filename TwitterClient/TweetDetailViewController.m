//
//  TweetDetailViewController.m
//  TwitterClient
//
//  Created by Sky Chen on 9/21/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "NSDate+DateTools.h"
#import <UIImageView+AFNetworking.h>
#import "ComposeViewController.h"
#import "TwitterClient.h"



@interface TweetDetailViewController () <ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation TweetDetailViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Tweet";
    
    // setup the layout
    self.statusView.layer.borderWidth = 1.0f;
    self.statusView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.actionView.layer.borderWidth = 1.0f;
    self.actionView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.nameLabel.text = self.tweet.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenname];
    self.tweetTextLabel.text = self.tweet.text;
    
//    NSLog(@"reteet count is %d", self.tweet.retweetCount);
//    NSLog(@"favorite count is %d", self.tweet.favoriteCount);
//    NSLog(@"reteeted is %d", self.tweet.retweeted);
//    NSLog(@"favorited is %d", self.tweet.favorited);
//    //NSLog(@"retweetedStatus is %@", self.tweet.retweetedStatus);
//    NSLog(@"idStr is %@", self.tweet.idStr);
//    NSLog(@"replyToIdStr is %@", self.tweet.replyToIdStr);
//    NSLog(@"retweetIdStr is %@", self.tweet.retweetIdStr);
    
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-action-inactive.png"] forState:UIControlStateDisabled];

    [self updateTweet];
    /*
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
     */
    
    //self.dateLabel.text = [self.tweet.createdAt ];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"M/d/yy, h:m a"];
//    self.dateLabel.text = [dateFormatter stringFromDate:self.tweet.createdAt];

    
    [self.profileImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]]
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                          // Here you can animate the alpha of the imageview from 0.0 to 1.0 in 0.3 seconds
                                          if (response != nil) {
                                              // NSLog(@"image is not cached");
                                              [self.profileImage setAlpha:0.0];
                                              [self.profileImage setImage:image];
                                              [UIView animateWithDuration:0.3 animations:^{
                                                  [self.profileImage setAlpha:1.0];
                                              }];
                                          } else {
                                              // NSLog(@"image is cached");
                                              [self.profileImage setImage:image];
                                          }
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                          // Your failure handle code
                                          NSLog(@"load image %@ failed.", self.tweet.user.profileImageUrl);
                                      }];

    
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

- (IBAction)onReply:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nvc = [storyboard instantiateViewControllerWithIdentifier:@"ComposeNavigationController"];
    
    ComposeViewController *vc = nvc.childViewControllers[0];
    vc.delegate = self;
    if (vc != nil) {
        vc.replyTweet = self.tweet;
    }
    
    [self.navigationController presentViewController:nvc animated:YES completion:^{
        NSLog(@"shown nvc completed");
    }];
}

- (void)didTweet:(Tweet *)tweet{
    NSLog(@"did Tweet in detail view");
    // update the view
//    NSLog(@"reteet count is %d", tweet.retweetCount);
//    NSLog(@"favorite count is %d", tweet.favoriteCount);
//    NSLog(@"reteeted is %d", tweet.retweeted);
//    NSLog(@"favorited is %d", tweet.favorited);
//    NSLog(@"replyToIdStr is %@", tweet.replyToIdStr);
//    NSLog(@"retweetIdStr is %@", tweet.retweetIdStr);
    [self.delegate didReply:tweet];
    
}


- (IBAction)onRetweet:(UIButton *)sender {
    //disable the button to prevent multiple touch before the current action completed.
    [self.retweetButton setEnabled:NO];
    if (self.tweet.retweeted == NO) {
        [[TwitterClient sharedInstance] retweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            [self.retweetButton setEnabled:YES];
            if (tweet != nil) {
                NSLog(@"retweet success for id %@", tweet.retweetIdStr);
                self.tweet = tweet;
                [self updateTweet];
                [self.delegate didRetweet:tweet];
            } else {
                NSLog(@"error when retweet %@", error);
            }
        }];
    } else {
        [[TwitterClient sharedInstance] unretweetWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            [self.retweetButton setEnabled:YES];
            if (tweet != nil) {
                NSLog(@"unretweet success for id %@", tweet.idStr);
                
                self.tweet = tweet;
                self.tweet.retweetCount -= 1;
                self.tweet.retweeted = NO;
                //self.tweet.retweetIdStr = nil;
                // update the view based on the tweet
                [self updateTweet];
                [self.delegate didRetweet:tweet];
                
            } else {
                NSLog(@"error when unretweet %@", error);
                
            }
            
        }];
    }

}


- (IBAction)onLike:(UIButton *)sender {
    //disable the button to prevent multiple touch before the current action completed.
    [self.likeButton setEnabled:NO];
    
    if (self.tweet.favorited == NO) {
        [[TwitterClient sharedInstance] favoriteWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            [self.likeButton setEnabled:YES];
            if (tweet != nil) {
                NSLog(@"like success for id %@", tweet.idStr);
                self.tweet = tweet;
                if (tweet.favoriteCount == 0) {
                    tweet.favoriteCount = 1;
                }
                [self updateTweet];
                [self.delegate didFavorite:tweet];
            } else {
                NSLog(@"error when retweet %@", error);
                
            }
        }];
    } else {
        [[TwitterClient sharedInstance] unfavoriteWithParams:nil tweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            [self.likeButton setEnabled:YES];
            if (tweet != nil) {
                NSLog(@"unlike success for id %@", tweet.idStr);
                
                self.tweet = tweet;
                [self updateTweet];
                [self.delegate didFavorite:tweet];
            } else {
                NSLog(@"error when unlike %@", error);
            }
            
        }];
    }
}


- (void)updateTweet{
    // update the retweet button and tweet count
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d",self.tweet.favoriteCount];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M/d/yy, h:m a"];
    self.dateLabel.text = [dateFormatter stringFromDate:self.tweet.createdAt];
    
    
    
    if (self.tweet.retweeted == YES) {
        NSLog(@"update reteet icon to retweet-action-on.png");
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-action-on.png"] forState:UIControlStateNormal];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-action-on-pressed.png"] forState:UIControlStateHighlighted];
        
        
    } else {
        NSLog(@"update reteet icon to retweet-action.png");
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-action.png"] forState:UIControlStateNormal];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-action-pressed.png"] forState:UIControlStateHighlighted];
        
    }
    
    if (self.tweet.favorited == YES) {
        [self.likeButton setImage:[UIImage imageNamed:@"like-action-on.png"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"like-action-on-pressed.png"] forState:UIControlStateHighlighted];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like-action.png"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"like-action-pressed.png"] forState:UIControlStateHighlighted];
    }
    
    [self.view layoutIfNeeded];
}


@end
