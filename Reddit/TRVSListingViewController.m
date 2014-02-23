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

static NSString *CellIdentifier = @"com.travisjeffery.cell.listing";

@interface TRVSListingViewController ()

@property (nonatomic, strong) TRVSSubreddit *subreddit;
@property (nonatomic, strong) NSCache *cellHeightCache;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
    
    self.title = self.subreddit.displayName;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TRVSListing *listing = [self listingForIndexPath:indexPath];
    
    cell.textLabel.text = listing.title;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    
    if ([self.cellHeightCache objectForKey:indexPath]) {
        height = [[self.cellHeightCache objectForKey:indexPath] floatValue];
    } else {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        [cell layoutIfNeeded];
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [self.cellHeightCache setObject:@(height) forKey:indexPath];
    }
    
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subreddit.listings.count;
}

#pragma mark - Private

- (TRVSListing *)listingForIndexPath:(NSIndexPath *)indexPath {
    return self.subreddit.listings[indexPath.row];
}

@end
