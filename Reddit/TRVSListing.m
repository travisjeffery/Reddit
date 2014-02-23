//
//  TRVSListing.m
//  Reddit
//
//  Created by Travis Jeffery on 2/22/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSListing.h"

@implementation TRVSListing

- (NSString *)title {
    return self.dictionary[@"title"];
}

- (NSNumber *)commentCount {
    return self.dictionary[@"num_comments"];
}

- (BOOL)hasVisited {
    return [self.dictionary[@"visited"] boolValue];
}

- (NSURL *)URL {
    return [NSURL URLWithString:self.dictionary[@"url"]];
}

- (NSNumber *)score {
    return self.dictionary[@"score"];
}

@end
