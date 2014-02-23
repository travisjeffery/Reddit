//
//  TRVSListingViewController.h
//  Reddit
//
//  Created by Travis Jeffery on 2/22/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TRVSSubreddit;

@interface TRVSListingViewController : UITableViewController

- (instancetype)initWithSubreddit:(TRVSSubreddit *)subreddit;

@end
