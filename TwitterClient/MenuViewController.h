//
//  MenuViewController.h
//  TwitterClient
//
//  Created by Sky Chen on 9/23/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HamburgerViewController.h"

#import "ProfileViewController.h"
#import "MentionsViewController.h"


@interface MenuViewController : UIViewController

@property (nonatomic, weak) HamburgerViewController *hamburgerViewController;



@property (nonatomic, strong) MentionsViewController * mentionsViewController;


@property (nonatomic, strong) UINavigationController * tweetsNavigationController;
@property (nonatomic, strong) UINavigationController * profileNavigationController;

-(void) showInitViewController;

@end
