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

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
    
    [TRVSRedditAPIClient.sharedClient fetchSubscribedSubredditsUsingBlock:^(NSArray *subreddits, NSError *error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            self.user.subreddits = subreddits;

           [self.tableView reloadData];
        }];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.user.subreddits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TRVSSubreddit *subreddit = [self subredditForIndexPath:indexPath];

    cell.textLabel.text = subreddit.displayName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TRVSSubreddit *subreddit = [self subredditForIndexPath:indexPath];
    
    [TRVSRedditAPIClient.sharedClient fetchSubredditListingWithName:subreddit.displayName order:TRVSRedditAPIClientListingOrderHot block:^(NSArray *listings, NSError *error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            TRVSListingViewController *viewController = [[TRVSListingViewController alloc] initWithListings:listings];            
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }];
}

#pragma mark - Private

- (TRVSSubreddit *)subredditForIndexPath:(NSIndexPath *)indexPath {
    return self.user.subreddits[indexPath.row];
}

- (TRVSUser *)user {
    return [TRVSUser currentUser];
}

@end
