//
//  TRVSLoginViewController.m
//  Reddit
//
//  Created by Travis Jeffery on 2/14/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

// view controllers
#import "TRVSLoginViewController.h"
#import "TRVSSubredditViewController.h"

// views
#import "TRVSLoginView.h"

// models
#import "TRVSUser.h"

// api
#import "TRVSRedditAPIClient.h"

@interface TRVSLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) TRVSLoginView *view;

@end

@implementation TRVSLoginViewController

@dynamic view;

- (void)loadView {
    [self loadLoginView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (TRVSRedditAPIClient.sharedClient.isLoggedIn) {
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
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
            }
        }];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self editTextFieldAfterTextField:textField];

    return NO;
}

#pragma mark - Private

- (void)loadLoginView {
    self.view = [TRVSLoginView new];
    self.view.usernameTextField.delegate = self;
    self.view.passwordTextField.delegate = self;
    [self.view.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)editTextFieldAfterTextField:(UITextField *)textField {
    if (textField == self.view.usernameTextField)
        [self.view.passwordTextField becomeFirstResponder];
    else {
        [self.view.passwordTextField resignFirstResponder];
        [self login:textField];
    }
}

- (void)showSubreddits {
    TRVSSubredditViewController *viewController = [[TRVSSubredditViewController alloc] initWithStyle:UITableViewStylePlain];

    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
    
    [viewController setupWithCompletionHandler:^{
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:YES completion:^{
            [activityIndicatorView removeFromSuperview];
        }];
    }];
}

@end
