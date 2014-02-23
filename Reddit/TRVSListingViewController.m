//
//  TRVSListingViewController.m
//  Reddit
//
//  Created by Travis Jeffery on 2/22/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSListingViewController.h"

// models

#import "TRVSListing.h"

static NSString *CellIdentifier = @"com.travisjeffery.cell.listing";

@interface TRVSListingViewController ()

@property (nonatomic, copy) NSArray *listings;

@end

@implementation TRVSListingViewController

- (instancetype)initWithListings:(NSArray *)listings {
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        _listings = [listings copy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellIdentifier];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TRVSListing *listing = [self listingForIndexPath:indexPath];
    
    cell.textLabel.text = listing.title;
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listings.count;
}

#pragma mark - Private

- (TRVSListing *)listingForIndexPath:(NSIndexPath *)indexPath {
    return self.listings[indexPath.row];
}

@end
