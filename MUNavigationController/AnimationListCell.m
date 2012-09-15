//
//  AnimationListCell.m
//  MUNavigationController
//
//  Created by Jonah Neugass on 9/15/12.
//  Copyright (c) 2012 Minds Unbound. All rights reserved.
//

#import "AnimationListCell.h"

@implementation AnimationListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
