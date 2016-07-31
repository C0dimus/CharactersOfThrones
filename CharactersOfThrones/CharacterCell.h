//
//  CharacterCell.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 28/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharactersViewModel.h"
#import "FavoriteButton.h"
#define CHARACTER_CELL_ID @"CharacterCellIdentifier"
@class CharacterCell;

@protocol CharacterCellDelegate <NSObject>

@required
- (void)cell:(CharacterCell*)cell favoriteButtonPressed:(FavoriteButton*)button withCharacterId:(NSInteger)characterId;

@end

@interface CharacterCell : UITableViewCell

@property(nonatomic, readwrite, copy) NSString *reuseIdentifier;
@property(weak, nonatomic) id<CharacterCellDelegate> delegate;

- (instancetype)initWithCharactersViewModel:(CharactersViewModel*)charactersVM andDelegate:(id<CharacterCellDelegate>)delegate;
- (void)fillWithCharacterId:(NSInteger)characterId;
- (CGFloat)getExpandedHeight;
- (void)shrinkAbstractLabel;

@end
