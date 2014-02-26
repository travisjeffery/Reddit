//
//  TRVSListing.h
//  Reddit
//
//  Created by Travis Jeffery on 2/22/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSModel.h"

@interface TRVSListing : TRVSModel

@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *commentCount;
@property (nonatomic, getter = hasVisited) BOOL visited;
@property (nonatomic) NSURL *URL;
@property (nonatomic) NSNumber *score;

@end
