//
//  Character.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 28/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "Character.h"
#import "Consts.h"

@implementation Character

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.characterId = [dictionary[JSON_ID] integerValue];
        self.title = dictionary[JSON_TITLE];
        self.url = dictionary[JSON_URL];
        self.thumbnailUrl = dictionary[JSON_THUMBNAIL];
        self.abstract = dictionary[JSON_ABSTRACT];
        self.isFavorite = [self isFavoriteFromUserDefaults];
    }
    return self;
}

-  (BOOL)isFavoriteFromUserDefaults {
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_FAVORITE_CHARACTER_ID(self.characterId)] ? : NO;
}

- (void)setIsFavorite:(BOOL)isFavorite {
    _isFavorite = isFavorite;
    [[NSUserDefaults standardUserDefaults] setBool:isFavorite forKey:KEY_FAVORITE_CHARACTER_ID(self.characterId)];
    
}

@end
