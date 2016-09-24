//
//  ProfileViewController.m
//  TwitterClient
//
//  Created by Sky Chen on 9/23/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "ProfileViewController.h"
#import <UIImageView+AFNetworking.h>

@interface ProfileViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIView *profileBorderView;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.user == nil) {
        NSLog(@"user is null, setting to default user");
        self.user = [User currentUser];
        //self.navigationItem.leftBarButtonItems = self.tweetsNavigationController.navigationItem.leftBarButtonItems;
    }
    
    NSLog(@"user name is %@", self.user.name);
    
    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",self.user.screenname];

    self.tweetsCountLabel.text = [NSString stringWithFormat:@"%d",self.user.statusesCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d",self.user.favouritesCount];
    self.followerCountLabel.text = [NSString stringWithFormat:@"%d",self.user.followersCount];
    
    self.bannerImage.backgroundColor = [self colorFromHexString:self.user.profileBgColor];
    
    
    
    self.navigationItem.title = self.user.name;

    self.profileBorderView.layer.cornerRadius = 5;
    
    [self.profileImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.user.profileImageUrl]]
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                          // Here you can animate the alpha of the imageview from 0.0 to 1.0 in 0.3 seconds
                                          if (response != nil) {
                                              // NSLog(@"image is not cached");
                                              [self.profileImage setAlpha:0.0];
                                              [self.profileImage setImage:image];
                                              [UIView animateWithDuration:0.3 animations:^{
                                                  [self.profileImage setAlpha:1.0];
                                              }];
                                          } else {
                                              // NSLog(@"image is cached");
                                              [self.profileImage setImage:image];
                                          }
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                          // Your failure handle code
                                          NSLog(@"load image %@ failed.", self.user.profileImageUrl);
                                      }];
    
    
    
    [self.bannerImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.user.profileBannerImageUrl]]
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                          // Here you can animate the alpha of the imageview from 0.0 to 1.0 in 0.3 seconds
                                          if (response != nil) {
                                              // NSLog(@"image is not cached");
                                              [self.bannerImage setAlpha:0.0];
                                              [self.bannerImage setImage:image];
                                              [UIView animateWithDuration:0.3 animations:^{
                                                  [self.bannerImage setAlpha:1.0];
                                              }];
                                          } else {
                                              // NSLog(@"image is cached");
                                              [self.bannerImage setImage:image];
                                          }
                                      }
                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                          // Your failure handle code
                                          NSLog(@"load image %@ failed.", self.user.profileBannerImageUrl);
                                      }];

    
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

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
/*
- (IBAction)onViewProfile:(UIButton *)sender {
    
}
 */

- (IBAction)onButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
