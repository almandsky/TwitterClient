//
//  ComposeViewController.h
//  TwitterClient
//
//  Created by Sky Chen on 9/21/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didTweet:(Tweet *)tweet;

@optional

- (void)didTweetSuccessfully;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) Tweet *replyTweet;

@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;

@end
