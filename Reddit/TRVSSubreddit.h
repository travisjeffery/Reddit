//
//  TRVSSubreddit.h
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSModel.h"

@interface TRVSSubreddit : TRVSModel

@property (readonly) NSString *title;
@property (readonly) NSString *publicDescription;
@property (readonly) NSNumber *subscribersCount;

@end
