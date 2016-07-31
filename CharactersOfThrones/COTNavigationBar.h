//
//  COTNavigationBar.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteButton.h"

@protocol COTNavigationBarDelegate <NSObject>

@required
- (NSString*)cotNavigationBarTitle;

@optional
- (BOOL)isBackButtonVisible;
- (BOOL)isFavoriteButtonVisible;
- (void)backButtonPressed;

@end

@interface COTNavigationBar : UINavigationBar

@property (weak, nonatomic) id<COTNavigationBarDelegate> navbarDelegate;
@property (weak, nonatomic) id<FavoriteButtonDelegate> favoriteButtonDelegate;

- (instancetype)initWithNavbarDelegate:(id<COTNavigationBarDelegate>)navbarDelegate andFavoriteButtonDelegate:(id<FavoriteButtonDelegate>)favoriteButtonDelegate;

@end
