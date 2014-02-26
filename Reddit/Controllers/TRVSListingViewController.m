//
//  TRVSListingViewController.m
//  Reddit
//
//  Created by Travis Jeffery on 2/22/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSListingViewController.h"

// models

#import "TRVSSubreddit.h"
#import "TRVSListing.h"

// views

#import "TRVSLabelCell.h"

// api

#import "TRVSRedditAPIClient.h"

static NSString *CellIdentifier = @"com.travisjeffery.cell.listing";

@interface TRVSListingViewController ()

@property (nonatomic, strong) TRVSSubreddit *subreddit;
@property (nonatomic, strong) NSCache *cellHeightCache;
@property (nonatomic, strong) UITableViewCell *heightCell;

@end

@implementation TRVSListingViewController

- (instancetype)initWithSubreddit:(TRVSSubreddit *)subreddit {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        _subreddit = subreddit;
        _cellHeightCache = [NSCache new];
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:TRVSLabelCell.class forCellReuseIdentifier:CellIdentifier];
    
    self.title = self.subreddit.displayName;
}


#pragma mark - TRVSViewControllerSetup

- (void)setupWithCompletionHandler:(TRVSCompletionHandler)completionHandler {
    [TRVSRedditAPIClient.sharedClient fetchSubredditListingWithName:self.subreddit.displayName order:TRVSRedditAPIClientListingOrderHot block:^(NSArray *listings, NSError *error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            self.subreddit.listings = listings;
            if (completionHandler) completionHandler();
        }];
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    
    if ([self.cellHeightCache objectForKey:indexPath]) {
        height = [[self.cellHeightCache objectForKey:indexPath] floatValue];
    } else {
        [self configureCell:self.heightCell atIndexPath:indexPath];
        self.heightCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.heightCell.bounds));
        [self.heightCell layoutIfNeeded];
        height = [self.heightCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [self.cellHeightCache setObject:@(height) forKey:indexPath];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subreddit.listings.count;
}

#pragma mark - Private

- (TRVSListing *)listingForIndexPath:(NSIndexPath *)indexPath {
    return self.subreddit.listings[indexPath.row];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TRVSListing *listing = [self listingForIndexPath:indexPath];

    cell.textLabel.text = listing.title;
}

- (UITableViewCell *)heightCell {
    if (!_heightCell) {
        _heightCell = [[TRVSLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return _heightCell;
}

@end
