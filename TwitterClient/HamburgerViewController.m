//
//  HamburgerViewController.m
//  TwitterClient
//
//  Created by Sky Chen on 9/23/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "HamburgerViewController.h"
#import "MenuViewController.h"

@interface HamburgerViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@property (nonatomic, strong) MenuViewController *menuViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@property (nonatomic, assign) CGPoint contentViewOriginalCenter;
@property (nonatomic, assign) BOOL isContentOpen;

@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    /*
    UINavigationController *nvc = [storyboard instantiateViewControllerWithIdentifier:@"MenuNavigationController"];
    self.menuViewController = nvc.childViewControllers[0];
    */
    self.leftMarginConstraint.constant = 0;
    
    self.menuViewController = [storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    self.menuViewController.view.frame = self.view.bounds;
    self.menuViewController.hamburgerViewController = self;
    [self.menuView addSubview:self.menuViewController.view];
    
    [self.menuViewController showInitViewController];
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


- (void)setContentViewController:(UIViewController *)contentViewController {
    [self addChildViewController:contentViewController];
    contentViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:contentViewController.view];

    [contentViewController didMoveToParentViewController:self];
}


- (void)openMenu {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.leftMarginConstraint.constant = 200;
        self.isContentOpen = YES;
        [self.view layoutIfNeeded];
    }];
}

- (void)closeMenu {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.leftMarginConstraint.constant = 0;
        self.isContentOpen = NO;
        [self.view layoutIfNeeded];
    }];
}

- (void) taggleMenu{
    if (self.isContentOpen) {
        [self closeMenu];
    } else {
        [self openMenu];
    }
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.contentViewOriginalCenter = self.contentView.center;

    } else if (sender.state == UIGestureRecognizerStateChanged) {

        
        self.contentView.center = CGPointMake(self.contentViewOriginalCenter.x + translation.x,
                                           self.contentViewOriginalCenter.y);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.contentView.center = self.contentViewOriginalCenter;
                         }];

        if (velocity.x < 0) {
            [self closeMenu];
        } else {
            [self openMenu];
        }
    }
}



@end
