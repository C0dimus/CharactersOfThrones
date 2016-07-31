//
//  CharactersViewModel.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 29/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"
#import <UIKit/UIKit.h>

@protocol CharactersViewModelDelegate <NSObject>

@required
- (void)onGetCharactersSucceed;
- (void)onGetCharactersFailed;
- (void)onGetThumbnail;

@end

@interface CharactersViewModel : NSObject

@property (weak, nonatomic) id<CharactersViewModelDelegate> delegate;

- (instancetype)initWithDelegate:(id<CharactersViewModelDelegate>)delegate;
- (UIImage*)imageForCharacterId:(NSInteger)characterId;
- (NSString*)titleForCharacterId:(NSInteger)characterId;
- (NSString*)abstarctForCharacterId:(NSInteger)characterId;
- (NSURL*)wikiArticleUrlForCharacterId:(NSInteger)characterId;
- (BOOL)isFavoriteCharacterWithId:(NSInteger)characterId;

- (NSInteger)numberOfAllCharacters;
- (NSInteger)numberOfFavoriteCharacters;
- (NSInteger)characterIdForRow:(NSInteger)row isFavoriteModeActive:(BOOL)isFavoriteModeActive;

- (void)changeFavoriteSateForCharacterWithId:(NSInteger)characterId;

@end
