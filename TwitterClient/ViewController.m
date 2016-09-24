//
//  ViewController.m
//  TwitterClient
//
//  Created by Sky Chen on 9/19/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "ViewController.h"
#import "TwitterClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)onLogin:(UIButton *)sender {
    
    [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"Welcome to %@", user.name);
            // present the tweets view
            [self performSegueWithIdentifier:@"loginSegue2" sender: self];
        } else {
            NSLog(@"failed to login with error %@", error);
        }
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
