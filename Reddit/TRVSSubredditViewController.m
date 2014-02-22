//
//  TRVSSubredditViewController.m
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSSubredditViewController.h"

#import "TRVSRedditAPIClient.h"

#import "TRVSUser.h"
#import "TRVSSubreddit.h"

@interface TRVSSubredditViewController ()

@property (readonly) TRVSUser *user;

@end

static NSString *CellIdentifier = @"SubredditCell";

@implementation TRVSSubredditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
    
    [TRVSRedditAPIClient.sharedClient fetchSubscribedSubredditsUsingBlock:^(NSDictionary *JSON, NSError *error) {
       dispatch_async(dispatch_get_main_queue(), ^{           
           [self.tableView reloadData];
       });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.user.subreddits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TRVSSubreddit *subreddit = [self subredditForIndexPath:indexPath];
    cell.textLabel.text = subreddit.name;
    return cell;
}

#pragma mark - Private

- (TRVSSubreddit *)subredditForIndexPath:(NSIndexPath *)indexPath {
    return self.user.subreddits[indexPath.row];
}

- (TRVSUser *)user {
    return [TRVSUser currentUser];
}

@end
