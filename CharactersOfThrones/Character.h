//
//  Character.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 28/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Character : NSObject

@property (nonatomic) NSInteger characterId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *thumbnailUrl;
@property (strong, nonatomic) NSString *abstract;
@property (nonatomic) BOOL isFavorite;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
