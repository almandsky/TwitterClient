//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Sky Chen on 9/19/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1SessionManager

+ (TwitterClient *) sharedInstance;
- (void) loginWithCompletion: (void (^)(User *user, NSError *error)) completion;
- (void) openURL: (NSURL *)url;

- (void) homeTimelineWithParams: (NSDictionary *) params : (void (^)(NSArray *tweets, NSError *error)) completion;

@end
