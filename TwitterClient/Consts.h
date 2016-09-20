//
//  Consts.h
//  TwitterClient
//
//  Created by Sky Chen on 9/20/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Consts : NSObject

@property (nonatomic, strong) NSString *const kTwitterConsumerKey;
@property (nonatomic, strong) NSString *const kTwitterConsumerSecret;
@property (nonatomic, strong) NSString *const kTwitterBaseUrl;


+ (NSString *) kTwitterConsumerKey;
+ (NSString *) kTwitterConsumerSecret;
+ (NSString *) kTwitterBaseUrl;

@end
