//
//  ComposeViewController.m
//  TwitterClient
//
//  Created by Sky Chen on 9/21/16.
//  Copyright © 2016 Sky Chen. All rights reserved.
//

#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewBottom;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *remainCharLabel;
@property (nonatomic, assign) BOOL canTweet;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTextView.delegate = self;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // set border of the view
    self.statusView.layer.borderWidth = 1.0f;
    self.statusView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    // set border of the tweet button
    self.tweetButton.layer.borderWidth = 1.0f;
    self.tweetButton.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.tweetButton.layer.cornerRadius = 5;
    
    self.canTweet = NO;
    
    [self.tweetTextView becomeFirstResponder];
    
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

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    NSDictionary *userInfo = [notification userInfo];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    NSValue      *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    self.statusViewBottom.constant = rawFrame.size.height;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    NSDictionary *userInfo = [notification userInfo];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    NSValue      *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    self.statusViewBottom.constant = rawFrame.size.height;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"What's happening?";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"What's happening?"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
- (IBAction)onBackButton:(UIBarButtonItem *)sender {
    [self.tweetTextView endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView{
    long remaining = 140 - textView.text.length;
    self.remainCharLabel.text = [NSString stringWithFormat:@"%ld", remaining];
    if (textView.text.length > 0 && remaining >=0 && remaining <=140) {
        // valid input
        self.canTweet = YES;
        [self.tweetButton setEnabled:YES];
        self.tweetButton.userInteractionEnabled = YES;
        self.tweetButton.layer.backgroundColor=[[UIColor blueColor] CGColor];
        [self.tweetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // set the label text color
        if (remaining < 20) {
            self.remainCharLabel.textColor = [UIColor redColor];
        } else {
            self.remainCharLabel.textColor = [UIColor lightGrayColor];
        }
        
    } else {
        // invalid input
        self.canTweet = NO;
        [self.tweetButton setEnabled:NO];
        self.tweetButton.userInteractionEnabled = NO;
        [self.tweetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.tweetButton.layer.backgroundColor=[[UIColor groupTableViewBackgroundColor] CGColor];
        
        if (remaining < 0) {
            self.remainCharLabel.textColor = [UIColor redColor];
        } else {
            // empty status
            self.remainCharLabel.textColor = [UIColor lightGrayColor];
        }
    }
}

- (IBAction)onTweet:(UIButton *)sender {
    NSLog(@"tweet button clicked");
    // post the tweet
    //Tweet *tweet = [[Tweet alloc] init
    
    [[TwitterClient sharedInstance] tweetWithStringParams:nil :self.tweetTextView.text :^(NSString *id_str, NSError *error) {
        if (id_str != nil) {
            // get new tweet
            NSLog(@"get new tweet id %@", id_str);
            [self.tweetTextView endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"error posting tweet %@", error);
        }
    }];
     
    /*
    [[TwitterClient sharedInstance] tweetWithString:nil :self.tweetTextView.text :^(Tweet *tweet, NSError *error) {
        if (tweet != nil) {
            // get new tweet
            NSLog(@"get new tweet id %@", tweet.text);
            
            // add the new tweet to the home timeline
            
            // dismiss the the compose screen
            [self.tweetTextView endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"error posting tweet %@", error);
        }
    }];
     */
    
}

@end
