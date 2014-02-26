//
//  TRVSSubredditViewController.m
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

// view controllers
#import "TRVSSubredditViewController.h"
#import "TRVSListingViewController.h"

// models
#import "TRVSUser.h"
#import "TRVSSubreddit.h"

// api
#import "TRVSRedditAPIClient.h"

@interface TRVSSubredditViewController ()

@property (readonly) TRVSUser *user;

@end

static NSString *CellIdentifier = @"com.travisjeffery.cell.subreddit";

@implementation TRVSSubredditViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
    
    self.title = NSLocalizedString(@"my subscribed subreddits", nil);
}

#pragma mark - TRVSViewControllerSetup

- (void)setupWithCompletionHandler:(TRVSCompletionHandler)completionHandler {
    [TRVSRedditAPIClient.sharedClient fetchSubscribedSubredditsUsingBlock:^(NSArray *subreddits, NSError *error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:nil] show];
            } else {
                self.user.subreddits = subreddits;
                if (completionHandler) completionHandler();
            }
        }];
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TRVSSubreddit *subreddit = [self subredditForIndexPath:indexPath];
    
    cell.textLabel.text = subreddit.displayName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TRVSListingViewController *viewController = [[TRVSListingViewController alloc] initWithSubreddit:[self subredditForIndexPath:indexPath]];
    
    [viewController setupWithCompletionHandler:^{
        [self.navigationController pushViewController:viewController animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.user.subreddits.count;
}

#pragma mark - Private

- (TRVSSubreddit *)subredditForIndexPath:(NSIndexPath *)indexPath {
    return self.user.subreddits[indexPath.row];
}

- (TRVSUser *)user {
    return [TRVSUser currentUser];
}

@end
