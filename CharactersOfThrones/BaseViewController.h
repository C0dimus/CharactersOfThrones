//
//  BaseViewController.h
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 28/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+AdditionalColors.h"
#import "Consts.h"
#import <Masonry.h>
#import "COTNavigationBar.h"

@interface BaseViewController : UIViewController <COTNavigationBarDelegate, FavoriteButtonDelegate>

@property (strong, nonatomic) COTNavigationBar *navigationBar;

@end
