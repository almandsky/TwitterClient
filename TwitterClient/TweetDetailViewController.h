//
//  TweetDetailViewController.h
//  TwitterClient
//
//  Created by Sky Chen on 9/21/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetDetailViewControllerDelegate <NSObject>

- (void)didReply:(Tweet *)tweet;
- (void)didRetweet:(Tweet *)tweet;
- (void)didFavorite:(Tweet *)tweet;



@end

@interface TweetDetailViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;

@property (nonatomic, weak) id <TweetDetailViewControllerDelegate> delegate;

- (void)updateTweet;

@end
