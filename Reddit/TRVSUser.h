//
//  TRVSUser.h
//  Reddit
//
//  Created by Travis Jeffery on 2/19/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRVSUser : NSObject <NSCoding>

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSArray *subreddits;

- (instancetype)initWithUsername:(NSString *)username;
+ (instancetype)currentUser;
+ (void)setCurrentUser:(TRVSUser *)user;

@end
