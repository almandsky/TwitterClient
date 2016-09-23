//
//  Tweet.m
//  TwitterClient
//
//  Created by Sky Chen on 9/19/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.text = dictionary[@"text"];
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
        fomatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [fomatter dateFromString:createdAtString];
        
        if ([dictionary[@"retweeted"] boolValue] == YES ) {
            self.retweeted = YES;
        } else {
            self.retweeted = NO;
        }
        
        if ([dictionary[@"favorited"] boolValue] == YES ) {
            self.favorited = YES;
        } else {
            self.favorited = NO;
        }
        
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        
        self.retweetedStatusDict = dictionary[@"retweeted_status"];

        self.idStr = dictionary[@"id_str"];
        
        if (dictionary[@"in_reply_to_user_id_str"]) {
            self.replyToIdStr = dictionary[@"in_reply_to_user_id_str"];
        }

        /*
        if (dictionary[@"current_user_retweet"]) {
            self.retweetIdStr = dictionary[@"current_user_retweet"][@"id_str"];
        } else if (!self.retweeted && ![self.user.screenname isEqualToString:[[User currentUser] screenname]]) {
            self.retweetIdStr = self.idStr;
        }*/

        if (self.retweetedStatusDict != nil) {
            self.retweetedStatus = [[Tweet alloc]initWithDictionary:self.retweetedStatusDict];
        }
        
        
        
    }
    return self;
}

+ (NSMutableArray *) tweetsWithArray: (NSArray *) array{
    NSMutableArray *tweets = [NSMutableArray array];

    for (NSDictionary *dic in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dic]];
    }
    
    return tweets;
}

@end
