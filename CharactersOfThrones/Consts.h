//
//  Consts.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 28/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#ifndef Consts_h
#define Consts_h

// Methods
#define LOCALIZED(s) NSLocalizedString(s, nil)
#define LOCALIZED_WITH_OBJ(s, obj) [NSString stringWithFormat:LOCALIZED(s), obj]

// HTTPs
#define HTTP_MAIN_ADDRESS @"http://gameofthrones.wikia.com"
#define HTTP_REQUEST_ADDRESS [HTTP_MAIN_ADDRESS stringByAppendingString:@"/api/v1/Articles/Top?expand=1&category=Characters&limit=75"]

// JSONs
#define JSON_ITEMS @"items"
#define JSON_ID @"id"
#define JSON_TITLE @"title"
#define JSON_URL @"url"
#define JSON_THUMBNAIL @"thumbnail"
#define JSON_ABSTRACT @"abstract"


// Dimensions
#define STATUS_BAR_HEIGHT 20
#define NAVIGATION_BAR_HEIGHT 50
#define CHARACTER_CELL_HEIGHT 100
#define THUMBNAIL_SIZE (CHARACTER_CELL_HEIGHT - DEFAULT_OFFSET * 2)
#define EMBLEM_IMAGE_SIZE 200
#define DEFAULT_OFFSET 20
#define FAVORITE_BUTTON_SIZE 60

// UserDefaults

#define KEY_FAVORITE_CHARACTER_ID(id) [NSString stringWithFormat:@"cot.key.favorite.character.id.%d", id]
#define KEY_FAVORITE_MODE_ACTIVE @"cot.key.favorite.mode.active"

#endif /* Consts_h */
