//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Sky Chen on 9/19/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "TwitterClient.h"
#import "Consts.h"


@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end


@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            NSLog(@"instance is nil, init it");
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:Consts.kTwitterBaseUrl] consumerKey:[Consts kTwitterConsumerKey] consumerSecret:Consts.kTwitterConsumerSecret];
        } else {
            NSLog(@"instance is not nil");
        }
    });
    return instance;
}

- (void) loginWithCompletion: (void (^)(User *user, NSError *error)) completion{
    self.loginCompletion = completion;
    [self.requestSerializer removeAccessToken];
    [self
     fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptsocialchatnode://oauth"] scope:nil
     success:^(BDBOAuth1Credential *requestToken) {
         NSLog(@"got the oauth token, %@", requestToken);
         
         // call the authentication URL
         NSString *oauthUrlString = [NSString stringWithFormat: @"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
         NSURL *oauthUrl = [NSURL URLWithString: oauthUrlString];
         [[UIApplication sharedApplication] openURL:oauthUrl];
         
         
     } failure:^(NSError *error) {
         NSLog(@"failed to get the oauth token");
         self.loginCompletion(nil, error);
     }];

}

- (void) openURL: (NSURL *)url {
    
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential  credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token %@", accessToken);
        [self.requestSerializer saveAccessToken:accessToken];
        
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"downloading current user");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"get current user data %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"user created, with name %@", user.name);
            self.loginCompletion(user, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failed to get current user");
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get the access token");
        self.loginCompletion(nil, error);
    }];
}

- (void) homeTimelineWithParams: (NSDictionary *) params : (void (^)(NSMutableArray *tweets, NSError *error)) completion {
    self.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"downloading home timeline");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"home timeline is %@", responseObject);
        NSMutableArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to load home timeline");
        completion(nil, error);
    }];
}

- (void) tweetWithStringParams: (NSDictionary *) params : (NSString *) tweetStr : (void (^)(NSString *id_str, NSError *error)) completion{

    NSString *postUrl = [NSString stringWithFormat:@"1.1/statuses/update.json?status=%@", [tweetStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    [self POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"constructingBodyWithBlock");
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"post tweet in progress");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"post request success");
        NSString *id = [NSString stringWithFormat:@"%@", responseObject[@"id_str"]];
        completion(id, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post tweet failed. error: %@", error);
        completion(nil, error);
    }];
}

- (void) tweetWithString: (NSDictionary *) params : (NSString *) tweetStr : (void (^)(Tweet *tweet, NSError *error)) completion{
    NSString *postUrl = [NSString stringWithFormat:@"1.1/statuses/update.json?status=%@", [tweetStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    [self POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"constructingBodyWithBlock");
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"post tweet in progress");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"post request success, response is %@", responseObject);
        Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(newTweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"post tweet failed. error: %@", error);
        completion(nil, error);
    }];
}


- (void)retweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *))completion {
    NSString *postUrl = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", [tweet.idStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    [self POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //code
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //code
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // get success reponse
        //NSLog(@"retweet sucess. result: %@", responseObject);
        Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(newTweet, nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"retweet failed. error: %@", error);
        completion(nil, error);
    }];
    
}

- (void)unretweetWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *tweet, NSError *))completion {
    
    
    NSString *postUrl = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", [tweet.idStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    NSLog(@"unretweet post url is %@", postUrl);
    
    [self POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //code
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //code
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // get success reponse
        //NSLog(@"unretweet sucess. result: %@", responseObject);
        Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(newTweet, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"unretweet failed. error: %@", error);
        completion(nil, error);
    }];
    
}

- (void)favoriteWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *postUrl = [NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", [tweet.idStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    [self POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //code
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //code
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // get success reponse
        NSLog(@"favorite sucess. result: %@", responseObject);
        Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(newTweet, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"favorite failed. error: %@", error);
        completion(nil, error);
    }];
}


- (void)unfavoriteWithParams:(NSDictionary *)params tweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *postUrl = [NSString stringWithFormat:@"1.1/favorites/destroy.json?id=%@", [tweet.idStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    [self POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //code
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //code
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // get success reponse
        NSLog(@"unfavorite sucess. result: %@", responseObject);
        Tweet *newTweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(newTweet, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"unfavorite failed. error: %@", error);
        completion(nil, error);
    }];
}

@end
