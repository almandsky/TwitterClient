//
//  HamburgerViewController.h
//  TwitterClient
//
//  Created by Sky Chen on 9/23/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HamburgerViewController : UIViewController


- (void)setContentViewController:(UIViewController *)contentViewController;

- (void)closeMenu;
- (void)openMenu;
- (void)taggleMenu;

@end
