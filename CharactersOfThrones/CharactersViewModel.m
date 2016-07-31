//
//  CharactersViewModel.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 29/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "CharactersViewModel.h"
#import "Consts.h"

@interface CharactersViewModel()

@property (strong, nonatomic) NSMutableArray <Character*> *characters;
@property (strong, nonatomic) NSMutableDictionary <NSString*, UIImage*> *images;

@end

@implementation CharactersViewModel

- (instancetype)initWithDelegate:(id<CharactersViewModelDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.characters = [@[] mutableCopy];
        self.images = [@{} mutableCopy];
        [self getCharactersFromWiki];
    }
    return self;
}

- (void)getCharactersFromWiki {
    NSString *dataUrl = HTTP_REQUEST_ADDRESS;
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadCharacters = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSError *jsonError = nil;
                                              NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                              [self setCharactersFromJson:jsonData];
                                              [self.delegate onGetCharactersSucceed];
                                          }];
    
    [downloadCharacters resume];
}

- (void)setCharactersFromJson:(NSDictionary*)json {
    for (NSDictionary *characterDict in json[JSON_ITEMS]) {
        Character *character = [[Character alloc] initWithDictionary:characterDict];
        [self.characters addObject:character];
        [self downloadImageForCharacter:character];
    }
        
}

- (void)downloadImageForCharacter:(Character*)character {
    NSURL *url = [NSURL URLWithString:character.thumbnailUrl];
    
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       self.images[character.thumbnailUrl] = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                           [self.delegate onGetThumbnailWithCharacterId:character.characterId];
                                                       });
                                                   }];
    
    [downloadPhotoTask resume];
}

- (Character*)characterWithId:(NSInteger)characterId {
    for (Character *character in self.characters) {
        if (characterId == character.characterId) {
            return character;
        }
    }
    return nil;
}

- (UIImage*)imageForCharacterId:(NSInteger)characterId {
    Character *character = [self characterWithId:characterId];
    return self.images[character.thumbnailUrl];
}

- (NSString*)titleForCharacterId:(NSInteger)characterId {
    return [self characterWithId:characterId].title;
}

- (NSString*)abstarctForCharacterId:(NSInteger)characterId {
    return [self characterWithId:characterId].abstract;
}

- (NSURL*)wikiArticleUrlForCharacterId:(NSInteger)characterId {
    NSString *url = [HTTP_MAIN_ADDRESS stringByAppendingString:[self characterWithId:characterId].url];
    return [NSURL URLWithString:url];
}

- (BOOL)isFavoriteCharacterWithId:(NSInteger)characterId {
    return [self characterWithId:characterId].isFavorite;
}

- (NSInteger)numberOfAllCharacters {
    return self.characters.count;
}

- (NSArray<Character*>*)favoriteCharacters {
    NSMutableArray *favoriteCharacters = [@[] mutableCopy];
    for (Character *character in self.characters) {
        if (character.isFavorite) {
            [favoriteCharacters addObject:character];
        }
    }
    return [NSArray arrayWithArray:favoriteCharacters];
}

- (NSInteger)numberOfFavoriteCharacters {
    return [self favoriteCharacters].count;
}

- (NSInteger)characterIdForRow:(NSInteger)row isFavoriteModeActive:(BOOL)isFavoriteModeActive {
    if (isFavoriteModeActive) {
        return [self favoriteCharacters][row].characterId;
    }
    
    return self.characters[row].characterId;
}

- (void)changeFavoriteSateForCharacterWithId:(NSInteger)characterId {
    Character *character = [self characterWithId:characterId];
    character.isFavorite = !character.isFavorite;
    
}


@end
