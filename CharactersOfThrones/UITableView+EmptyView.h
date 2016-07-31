//
//  UITableView+EmptyView.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyViewDataSource <UITableViewDataSource>

- (UIView*)emptyViewForTable;

@end

@interface UITableView (EmptyView) <EmptyViewDataSource>

@end
