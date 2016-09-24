//
//  MenuViewController.m
//  TwitterClient
//
//  Created by Sky Chen on 9/23/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "MenuViewController.h"
#import "TweetsViewController.h"


//@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@interface MenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) TweetsViewController * tweetsViewController;
@property (nonatomic, strong) ProfileViewController * profileViewController;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    
    /*
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    //do something like background color, title, etc you self
    [self.view addSubview:navbar];
     
    [self.view layoutIfNeeded];
     */
    //self.tweetsViewController = [[TweetsViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //self.tweetsViewController = [storyboard instantiateViewControllerWithIdentifier:@"TweetsViewController"];
    self.tweetsNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"TweetsNavigationController"];
    self.profileNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileNavigationController"];
    self.tweetsViewController = self.tweetsNavigationController.childViewControllers[0];
    self.tweetsViewController.menuViewController = self;
    //self.profileViewController.tweetsViewController = self.tweetsViewController;
    
    self.profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    self.mentionsViewController = [storyboard instantiateViewControllerWithIdentifier:@"MentionsViewController"];
    
    
    /*
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
     */
    /*
    [self.hamburgerViewController setContentViewController:self.tweetsNavigationController];
     */
    
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
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 4;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Home Timeline";
        //cell.backgroundColor = [UIColor greenColor];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"Profile";
        //cell.backgroundColor = [UIColor blueColor];
    } else if (indexPath.row == 2){
        cell.textLabel.text = @"Mentions";
        //cell.backgroundColor = [UIColor redColor];
    } else {
        cell.textLabel.text = @"Logout";
        //cell.backgroundColor = [UIColor redColor];
    }
     
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self.hamburgerViewController setContentViewController:self.tweetsNavigationController];
    } else if (indexPath.row == 1) {
        [self.hamburgerViewController setContentViewController:self.profileNavigationController];
    } else if (indexPath.row == 2) {
        //[self.hamburgerViewController setContentViewController:self.mentionsViewController];
        [self.hamburgerViewController setContentViewController:self.tweetsNavigationController];
    } else {
        // logout
        [self logout];
    }
    
    [self.hamburgerViewController closeMenu];
}
*/
-(void) showInitViewController {
    [self.hamburgerViewController setContentViewController:self.tweetsNavigationController];
}
- (IBAction)onHome:(id)sender {
    [self.hamburgerViewController setContentViewController:self.tweetsNavigationController];
    [self.hamburgerViewController closeMenu];
}


- (void)logout {
    [[User currentUser] logout];
}
- (IBAction)onLogout:(id)sender {
    [self logout];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"identifier is %@", segue.identifier);
    
    //if ([segue.identifier isEqualToString:@"menuProfileViewSegue"]) {
        
        [self.hamburgerViewController closeMenu];
        
    //}
}

@end
