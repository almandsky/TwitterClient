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
    }
    return self;
}

+ (NSArray *) tweetsWithArray: (NSArray *) array{
    NSMutableArray *tweets = [NSMutableArray array];

    for (NSDictionary *dic in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dic]];
    }
    
    return tweets;
}

@end
