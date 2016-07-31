//
//  BaseViewController.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 28/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor appBackgroundColor]];
    [self.navigationController setNavigationBarHidden:YES];
    [self initCOTNavigationBar];
}

- (void)initCOTNavigationBar {
    self.navigationBar = [[COTNavigationBar alloc] initWithNavbarDelegate:self andFavoriteButtonDelegate:self];
    [self.view addSubview:self.navigationBar];
}

#pragma mark - COTNavigationBarDelegate

- (NSString *)cotNavigationBarTitle {
    return @"Characters of Thrones";
}


- (BOOL)isFavoriteButtonVisible {
    return YES;
}

- (BOOL)conditionForActiveFavoriteButtonImage {
    return NO;
}

#pragma mark - FavoriteButtonDelegate 
- (void)favoriteButtonPressed:(FavoriteButton *)button {
    
}

@end
