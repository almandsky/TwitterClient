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
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSDictionary *dictionary;


- (id) initWithDictionary: (NSDictionary *) dictionary;

+ (User *) currentUser;
+ (void) setCurrentUser: (User *) user;

- (void) logout;

@end
