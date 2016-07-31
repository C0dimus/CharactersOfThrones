//
//  FavoriteButton.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "FavoriteButton.h"

@implementation FavoriteButton

- (instancetype)initWithDelegate:(id<FavoriteButtonDelegate>)delegate andButtonState:(BOOL)isButtonActive {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.isButtonActive = isButtonActive;
        self.tintColor = [UIColor darkGrayColor];
        [self setImageDependingOnButtonState:isButtonActive];
        [self addTarget:self action:@selector(favoriteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<FavoriteButtonDelegate>)delegate {
    self = [self initWithDelegate:delegate andButtonState:NO];
    if (self) {
        [self setImageDependingOnButtonState:[delegate conditionForActiveFavoriteButtonImage]];
    }
    return self;
}

- (void)setImageDependingOnButtonState:(BOOL)isButtonActive {
    UIImage *starImage = isButtonActive ? [UIImage imageNamed:@"star_filled"] : [UIImage imageNamed:@"star"];
    [self setImage:starImage forState:UIControlStateNormal];
}

- (void)favoriteButtonPressed {
    [self.delegate favoriteButtonPressed:self];
    [self setImageDependingOnButtonState:[self.delegate conditionForActiveFavoriteButtonImage]];
}

@end
