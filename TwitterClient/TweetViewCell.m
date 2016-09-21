//
//  TweetViewCell.m
//  TwitterClient
//
//  Created by Sky Chen on 9/20/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "TweetViewCell.h"
#import "NSDate+DateTools.h"
#import <UIImageView+AFNetworking.h>

@implementation TweetViewCell

- (void)awakeFromNib {
    // Initialization code
    self.tweetTextLabel.text = self.tweet.text;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.tweet != nil) {
        self.nameLabel.text = self.tweet.user.name;
        self.screenNameLabel.text = self.tweet.user.screenname;
        self.tweetTextLabel.text = self.tweet.text;
        self.dateLabel.text = [self.tweet.createdAt shortTimeAgoSinceNow];
        
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
