//
//  User.m
//  TwitterClient
//
//  Created by Sky Chen on 9/19/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString *currentUserKey = @"kCurrentUserKey";
NSString *userDidLoginNotification = @"userDidLoginNotification";
NSString *userDidLogoutNotification = @"userDidLogoutNotification";

@implementation User

static User *currentUser;

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        
        self.name = dictionary[@"name"];
        self.screenname = dictionary[@"screen_name"];
        self.profileImageUrl = dictionary[@"profile_image_url_https"];
        self.profileBannerImageUrl = dictionary[@"profile_banner_url"];
        self.profileBgImageUrl = dictionary[@"profile_background_image_url_https"];
        self.profileBgColor = dictionary[@"profile_background_color"];
        
        self.statusesCount = [dictionary[@"statuses_count"] intValue];
        self.favouritesCount = [dictionary[@"favourites_count"] intValue];
        self.followersCount = [dictionary[@"followers_count"] intValue];
        
    }
    return self;
}

+ (User *) currentUser {
    if (currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:currentUserKey];
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingAllowFragments  error:nil];

            currentUser = [[User alloc] initWithDictionary:dict];
            
        }
    }
    return currentUser;
}
+ (void) setCurrentUser: (User *) user {
    currentUser = user;
    if (currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:user.dictionary options: NSJSONWritingPrettyPrinted error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:currentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:currentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:userDidLogoutNotification object:nil];
    
}

@end
