//
//  User.h
//  TwitterClient
//
//  Created by Sky Chen on 9/19/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *profileBannerImageUrl;
@property (nonatomic, strong) NSString *profileBgImageUrl;
@property (nonatomic, strong) NSString *profileBgColor;


@property (nonatomic, assign) int statusesCount;
@property (nonatomic, assign) int followersCount;
@property (nonatomic, assign) int favouritesCount;

@property (nonatomic, strong) NSDictionary *dictionary;


- (id) initWithDictionary: (NSDictionary *) dictionary;

+ (User *) currentUser;
+ (void) setCurrentUser: (User *) user;

- (void) logout;

@end
