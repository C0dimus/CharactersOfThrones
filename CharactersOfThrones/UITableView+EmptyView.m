//
//  UITableView+EmptyView.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "UITableView+EmptyView.h"

@implementation UITableView (EmptyView)

- (void)reloadDataAndShowEmptyViewIfNeeded {
    [self reloadData];
    NSInteger numberOfRows = [self numberOfRowsInSection:0];
    if (numberOfRows == 0) {
        
    }
}

@end
