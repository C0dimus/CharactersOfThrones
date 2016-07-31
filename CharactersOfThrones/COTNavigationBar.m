//
//  COTNavigationBar.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "COTNavigationBar.h"
#import <Masonry.h>
#import "Consts.h"
#import "UIColor+AdditionalColors.h"

@interface COTNavigationBar()

@property (strong, nonatomic) UIView *superView;

@end

@implementation COTNavigationBar

- (instancetype)initWithNavbarDelegate:(id<COTNavigationBarDelegate>)navbarDelegate
             andFavoriteButtonDelegate:(id<FavoriteButtonDelegate>)favoriteButtonDelegate {
    self = [super init];
    if (self) {
        self.navbarDelegate = navbarDelegate;
        self.favoriteButtonDelegate = favoriteButtonDelegate;
        [self setItems:@[[self navigationItem]]];
    }
    return self;
}

- (UINavigationItem*)navigationItem {
    UINavigationItem *navItem  = [[UINavigationItem alloc] initWithTitle:[_navbarDelegate cotNavigationBarTitle]];
    if([_navbarDelegate respondsToSelector:@selector(isFavoriteButtonVisible)] && [_navbarDelegate isFavoriteButtonVisible]) {
        navItem.rightBarButtonItem = [self rightBarButton];
    }
    if([_navbarDelegate respondsToSelector:@selector(isBackButtonVisible)] && [_navbarDelegate isBackButtonVisible]) {
        navItem.leftBarButtonItem = [self leftBarButton];
    }
    return navItem;
}

- (UIBarButtonItem*)rightBarButton {
    NSAssert([_favoriteButtonDelegate respondsToSelector:@selector(favoriteButtonPressed:)], @"Method favorteButtonPressed from FavoriteButtonDelegate must be implemented if favorite button is visible!");
    FavoriteButton *favoriteButton = [[FavoriteButton alloc] initWithDelegate:_favoriteButtonDelegate];
    favoriteButton.frame = CGRectMake(0.0, 0.0, 20, FAVORITE_BUTTON_SIZE);

    return [[UIBarButtonItem alloc] initWithCustomView:favoriteButton];
}

- (UIBarButtonItem*)leftBarButton {
    NSAssert([_navbarDelegate respondsToSelector:@selector(backButtonPressed)], @"Method backButtonPressed from COTNavigationBarDelegate must be implemented if back button is visible!");
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:_navbarDelegate action:@selector(backButtonPressed)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.superView = newSuperview;
}

- (void)didMoveToSuperview {
    if (self.superView) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_superView.mas_top).with.offset(STATUS_BAR_HEIGHT);
            make.leading.equalTo(_superView.mas_leading);
            make.trailing.equalTo(_superView.mas_trailing);
            make.height.equalTo(@(NAVIGATION_BAR_HEIGHT));
        }];
    }
}

@end
