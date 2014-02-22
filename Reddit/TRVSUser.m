//
//  TRVSUser.m
//  Reddit
//
//  Created by Travis Jeffery on 2/19/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSUser.h"

@implementation TRVSUser

- (instancetype)initWithUsername:(NSString *)username {
    self = [self init];
    if (self) {
        _username = [username copy];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        _id = @(-1);
        _username = @"n/a";
        _subreddits = @[];
    }
    return self;
}

static TRVSUser *__currentUser = nil;

+ (void)setCurrentUser:(TRVSUser *)user {
//    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"user"];
//    if ([[NSUserDefaults standardUserDefaults] synchronize]) {
        __currentUser = user;
//    } else {
//        // now what
//    }
}

+ (instancetype)currentUser {
    if (__currentUser == nil) {
        __currentUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    }
    return __currentUser;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.subreddits forKey:@"subreddits"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _id = [aDecoder decodeObjectForKey:@"id"];
        _username = [aDecoder decodeObjectForKey:@"username"];
        _subreddits = [aDecoder decodeObjectForKey:@"subreddits"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p> %@", self.class, self, self.username];
}

@end
