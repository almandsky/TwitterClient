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
#import "TweetDetailViewController.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"
#import "MenuViewController.h"


#import "MBProgressHUD.h"

@interface TweetsViewController () <UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, TweetDetailViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ComposeViewController *composeViewController;
@property (nonatomic, assign) long selectedIndex;

@end

@implementation TweetsViewController

- (void) fetchTweets {
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil :^(NSMutableArray *tweets, NSError *error) {
        //NSLog(@"get list of tweets %@", tweets);
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"indexPath is : %ld", (long) indexPath.row);
    
    TweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetViewCell"];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.tweet = self.tweets[indexPath.row];

    return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // unhighlight selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] init];
    //vc.delegate = self;
    vc.tweet = self.tweets[indexPath.row];
    //[self.navigationController pushViewController:vc animated:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"identifier is %@", segue.identifier);

    if ([segue.identifier isEqualToString:@"detailSegue"]){
        TweetViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        TweetDetailViewController *vc = segue.destinationViewController;
        vc.tweet = self.tweets[indexPath.row];
        vc.delegate = self;
        vc.navigationItem.rightBarButtonItems = self.navigationItem.rightBarButtonItems;
        // setup the delegate
    } else if ([segue.identifier isEqualToString:@"composeSegue"]) {
        NSLog(@"setting up the viewer");
        //self.composeViewController = (ComposeViewController *) segue.destinationViewController;
        //self.composeViewController.delegate = self;
        UINavigationController *nvc = (UINavigationController *) segue.destinationViewController;
        
        //UINavigationController *nvc = [storyboard instantiateViewControllerWithIdentifier:@"ComposeNavigationController"];
        
        ComposeViewController *vc = nvc.childViewControllers[0];
        vc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"profileViewSegue"]) {
        
        TweetViewCell *cell = (TweetViewCell*) [[sender superview] superview];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        Tweet *tweet = self.tweets[indexPath.row];
        
        UINavigationController *pnvc = segue.destinationViewController;
        
        
        ProfileViewController *pvc = pnvc.childViewControllers[0];
        
        pvc.user = tweet.user;
        

    }
}

- (void)didTweet:(Tweet *)tweet{
    NSLog(@"did Tweet in tweets view");
    // update the view
//    NSLog(@"reteet count is %d", tweet.retweetCount);
//    NSLog(@"favorite count is %d", tweet.favoriteCount);
//    NSLog(@"reteeted is %d", tweet.retweeted);
//    NSLog(@"favorited is %d", tweet.favorited);
//    NSLog(@"replyToIdStr is %@", tweet.replyToIdStr);
//    NSLog(@"retweetIdStr is %@", tweet.retweetIdStr);
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    
}

- (void)didReply:(Tweet *)tweet {
    NSLog(@"did get reply in in tweets view");
    [self didTweet:tweet];
}

- (void)didRetweet:(Tweet *)tweet {
    NSLog(@"didRetweet in tweets view");
    self.tweets[self.selectedIndex] = tweet;
}

- (void)didFavorite:(Tweet *)tweet {
    NSLog(@"didFavorite in tweets view");
    self.tweets[self.selectedIndex] = tweet;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
- (IBAction)onProfileTap:(UITapGestureRecognizer *)sender {
    
    NSLog(@"profile tap");
    //UINavigationController *nc = segue.destinationViewController;
    //TrailerViewController *tvc = nc.viewControllers[0];
    TweetViewCell *cell = (TweetViewCell*) [[sender superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if(self.isFiltered)
        tvc.movie = self.filteredTableData[indexPath.row];
    else
        tvc.movie = self.movies[indexPath.row];
    
}
 */
- (IBAction)onViewProfile:(UIButton *)sender {
    NSLog(@"profile tap");
    //UINavigationController *nc = segue.destinationViewController;
    //TrailerViewController *tvc = nc.viewControllers[0];
    
    /*
    UINavigationController *nc = segue.destinationViewController;
    TrailerViewController *tvc = nc.viewControllers[0];
    */
    
    TweetViewCell *cell = (TweetViewCell*) [[sender superview] superview];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    
    
    MenuViewController *mvc = self.menuViewController;
    
    UINavigationController *pnvc = mvc.profileNavigationController;
     
    
    ProfileViewController *pvc = pnvc.childViewControllers[0];
    
    pvc.user = tweet.user;
    
    pvc.navigationItem.leftBarButtonItems = self.navigationItem.leftBarButtonItems;
    pvc.navigationItem.rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    
    
    HamburgerViewController *hvc = mvc.hamburgerViewController;
    
    [hvc setContentViewController:pnvc];
    
    //[self.navigationController pushViewController:pvc animated:YES];
    
    
    
    //tvc.movie = self.movies[indexPath.row];
}
- (IBAction)onMenuClick:(UIBarButtonItem *)sender {
    MenuViewController *mvc = self.menuViewController;
    HamburgerViewController *hvc = mvc.hamburgerViewController;
    
    [hvc taggleMenu];
    
}

@end
