//
//  TRVSListingViewController.h
//  Reddit
//
//  Created by Travis Jeffery on 2/22/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TRVSCommon.h"
#import "TRVSViewControllerSetup.h"

@class TRVSSubreddit;

@interface TRVSListingViewController : UITableViewController <TRVSViewControllerSetup>

- (instancetype)initWithSubreddit:(TRVSSubreddit *)subreddit;

@end
