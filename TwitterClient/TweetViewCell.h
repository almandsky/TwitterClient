//
//  TweetViewCell.h
//  TwitterClient
//
//  Created by Sky Chen on 9/20/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetViewCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
