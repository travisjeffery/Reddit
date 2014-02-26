//
//  TRVSLabelCell.m
//  Reddit
//
//  Created by Travis Jeffery on 2/25/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

#import "TRVSLabelCell.h"

@implementation TRVSLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *textLabel = self.textLabel;
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[textLabel]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textLabel)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[textLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textLabel)]];
    }
    return self;
}

- (void)layoutSubviews {
    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    
    [super layoutSubviews];
}

@end
