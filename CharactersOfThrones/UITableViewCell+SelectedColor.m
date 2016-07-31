//
//  UITableViewCell+SelectedColor.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 29/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "UITableViewCell+SelectedColor.h"

@implementation UITableViewCell (SelectedColor)

- (void)setSelectedColor:(UIColor*)color {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = color;
    [self setSelectedBackgroundView:bgColorView];
}

@end
