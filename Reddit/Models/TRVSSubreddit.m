//
//  TRVSSubreddit.m
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSSubreddit.h"

@implementation TRVSSubreddit

- (NSString *)title {
    return self.dictionary[@"title"];
}

- (NSString *)publicDescription {
    return self.dictionary[@"public_description"];
}

- (NSNumber *)subscriberCount {
    return self.dictionary[@"subscribers"];
}

- (NSString *)displayName {
    return self.dictionary[@"display_name"];
}

@end
