//
//  TRVSLoginViewController.m
//  Reddit
//
//  Created by Travis Jeffery on 2/14/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSLoginViewController.h"
#import "TRVSSubredditViewController.h"

#import "TRVSLoginView.h"

#import "TRVSRedditAPIClient.h"

#import "TRVSUser.h"

@interface TRVSLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) TRVSLoginView *view;

@end

@implementation TRVSLoginViewController

@dynamic view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    self.view = [TRVSLoginView new];
    
    self.view.usernameTextField.delegate = self;
    self.view.passwordTextField.delegate = self;
    [self.view.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([TRVSUser currentUser]) {
        [self showSubreddits];
    } else {
        [self.view.usernameTextField becomeFirstResponder];
    }
}

#pragma mark - Actions

- (void)login:(id)sender {
    [self.view endEditing:YES];
    
    [TRVSRedditAPIClient.sharedClient loginUsingUsername:self.view.usernameTextField.text password:self.view.passwordTextField.text block:^(BOOL loggedIn, NSError *error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (loggedIn) {
                TRVSUser *user = [[TRVSUser alloc] initWithUsername:self.view.usernameTextField.text];
                [TRVSUser setCurrentUser:user];
                [self showSubreddits];
            } else {
                // do something with error
                // maybe color the text field red shake it and have a message saying what went wrong
            } 
        }];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.view.usernameTextField)
        [self.view.passwordTextField becomeFirstResponder];
    else {
        [self.view.passwordTextField resignFirstResponder];
        [self login:textField];
    }
    return NO;
}

#pragma mark - Private

- (void)showSubreddits {
    UIViewController *viewController = [[TRVSSubredditViewController alloc] initWithStyle:UITableViewStylePlain];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
