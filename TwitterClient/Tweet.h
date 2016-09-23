//
//  Tweet.h
//  TwitterClient
//
//  Created by Sky Chen on 9/19/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) int retweetCount;
@property (nonatomic, assign) int favoriteCount;
@property (nonatomic, strong) NSDictionary * retweetedStatusDict;
@property (nonatomic, strong) Tweet * retweetedStatus;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *replyToIdStr;
@property (nonatomic, strong) NSString *retweetIdStr;


- (id) initWithDictionary: (NSDictionary *) dictionary;

+ (NSMutableArray *) tweetsWithArray: (NSArray *) array;

@end
