//
//  TweetsViewController.m
//  TwitterClient
//
//  Created by Sky Chen on 9/20/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetViewCell.h"

#import "MBProgressHUD.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TweetsViewController

- (void) fetchTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil :^(NSArray *tweets, NSError *error) {
        NSLog(@"get list of tweets %@", tweets);
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
}

-(void)refresh:(id)sender {
    [self fetchTweets];
    [sender endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    // pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    [self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onLogout:(UIBarButtonItem *)sender {
    [[User currentUser] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"indexPath is : %ld", (long) indexPath.row);
    
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    cell.tweet = self.tweets[indexPath.row];

    return cell;
}

@end
