//
//  DetailsViewController.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "BaseViewController.h"
#import "CharactersViewModel.h"

@interface DetailsViewController : BaseViewController

- (instancetype)initWithCharactersViewModel:(CharactersViewModel*)charactersVM andCharacterId:(NSInteger)characterId;

@end
