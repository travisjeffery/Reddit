//
//  TRVSModel.m
//  Reddit
//
//  Created by Travis Jeffery on 2/13/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSModel.h"

@implementation TRVSModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {        
        _dictionary = [dictionary copy];
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, dictionary = %@>", self.class, self, self.dictionary];
}

@end
