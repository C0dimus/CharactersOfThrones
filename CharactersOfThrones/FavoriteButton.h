//
//  FavoriteButton.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FavoriteButton;

@protocol FavoriteButtonDelegate <NSObject>

@required
- (void)favoriteButtonPressed:(FavoriteButton*)button;
- (BOOL)conditionForActiveFavoriteButtonImage;

@end

@interface FavoriteButton : UIButton

@property (weak, nonatomic) id<FavoriteButtonDelegate> delegate;
@property (nonatomic) BOOL isButtonActive;

- (instancetype)initWithDelegate:(id<FavoriteButtonDelegate>)delegate;
- (instancetype)initWithDelegate:(id<FavoriteButtonDelegate>)delegate andButtonState:(BOOL)isButtonActive;
- (void)setImageDependingOnButtonState:(BOOL)isButtonActive;

@end
