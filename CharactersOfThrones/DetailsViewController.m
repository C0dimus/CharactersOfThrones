//
//  DetailsViewController.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 30/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "DetailsViewController.h"
#import "EmblemImageView.h"
#import <UIView+Toast.h>

@interface DetailsViewController()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) EmblemImageView *emblemImageView;
@property (strong, nonatomic) UILabel *abstractLabel;
@property (strong, nonatomic) UIButton *wikiButton;
@property (nonatomic) NSInteger characterId;
@property (strong, nonatomic) CharactersViewModel *charactersVM;

@end

@implementation DetailsViewController

- (instancetype)initWithCharactersViewModel:(CharactersViewModel *)charactersVM andCharacterId:(NSInteger)characterId {
    self = [super init];
    if (self) {
        self.charactersVM = charactersVM;
        self.characterId = characterId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initScrollView];
    [self initEmblemImageView];
    [self initAbstractLabel];
    [self initWikiButton];
}

- (BOOL)isPortraitOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)initScrollView {
    self.scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView *helperScrollView = [UIView new];
    [self.scrollView addSubview:helperScrollView];
    [helperScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.leading.equalTo(self.scrollView.mas_leading);
        make.trailing.equalTo(self.scrollView.mas_trailing);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@0);
    }];
}


- (void)initEmblemImageView {
    self.emblemImageView = [[EmblemImageView alloc] initWithImage:[self.charactersVM imageForCharacterId:self.characterId]];
    [self.scrollView addSubview:self.emblemImageView];
    [self remakeEmblemImageViewConstraintsDepentingOnOrientation];
}

- (void)remakeEmblemImageViewConstraintsDepentingOnOrientation {
    if ([self isPortraitOrientation]) {
        [self.emblemImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top).with.offset(DEFAULT_OFFSET);
            make.centerX.equalTo(self.view.mas_centerX);
            make.width.equalTo(@(EMBLEM_IMAGE_SIZE));
            make.height.equalTo(@(EMBLEM_IMAGE_SIZE));
        }];
    } else {
        [self.emblemImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView.mas_centerY);
            make.leading.equalTo(self.scrollView.mas_leading).with.offset(DEFAULT_OFFSET);
            make.width.equalTo(@(EMBLEM_IMAGE_SIZE));
            make.height.equalTo(@(EMBLEM_IMAGE_SIZE));
        }];
    }
}

- (void)initAbstractLabel {
    self.abstractLabel = [UILabel new];
    self.abstractLabel.numberOfLines = 0;
    self.abstractLabel.text = [self.charactersVM abstarctForCharacterId:self.characterId];
    self.abstractLabel.font = [UIFont systemFontOfSize:16];
    self.abstractLabel.textColor = [UIColor grayColor];
    [self.scrollView addSubview:self.abstractLabel];
    [self remakeAbstractLabelConstraintsDependingOnOrientation];
}

- (void)remakeAbstractLabelConstraintsDependingOnOrientation {
    if([self isPortraitOrientation]) {
        [self.abstractLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emblemImageView.mas_bottom).with.offset(DEFAULT_OFFSET);
            make.leading.equalTo(self.scrollView.mas_leading).with.offset(DEFAULT_OFFSET);
            make.trailing.equalTo(self.scrollView.mas_trailing).with.offset(-DEFAULT_OFFSET);
        }];
    } else {
        [self.abstractLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.emblemImageView.mas_centerY).multipliedBy(.5f);
            make.leading.equalTo(self.emblemImageView.mas_trailing).with.offset(DEFAULT_OFFSET);
            make.trailing.equalTo(self.scrollView.mas_trailing).with.offset(-DEFAULT_OFFSET);
        }];
    }
}

- (void)initWikiButton {
    self.wikiButton = [UIButton new];
    [self.wikiButton addTarget:self action:@selector(wikiButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.wikiButton setImage:[UIImage imageNamed:@"wiki"] forState:UIControlStateNormal];
    [self.scrollView addSubview:self.wikiButton];
    [self remakeWikiButtonConstraintsDependingOnOrientation];
}

- (void)remakeWikiButtonConstraintsDependingOnOrientation {
    if([self isPortraitOrientation]) {
        [self.wikiButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.abstractLabel.mas_bottom).with.offset(DEFAULT_OFFSET);
            make.centerX.equalTo(self.scrollView.mas_centerX);
        }];
    } else {
        [self.wikiButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.emblemImageView.mas_centerY).multipliedBy(1.5f);
            make.centerX.equalTo(self.abstractLabel.mas_centerX);
        }];
    }
}

- (void)updateAllConstraints {
    [self remakeEmblemImageViewConstraintsDepentingOnOrientation];
    [self remakeAbstractLabelConstraintsDependingOnOrientation];
    [self remakeWikiButtonConstraintsDependingOnOrientation];
    [UIView animateWithDuration:.3f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self updateAllConstraints];
    }];
}

- (void)wikiButtonPressed {
    [[UIApplication sharedApplication] openURL:[self.charactersVM wikiArticleUrlForCharacterId:self.characterId]];
}


#pragma mark - COTNavigationBarDelegate 

- (NSString *)cotNavigationBarTitle {
    return [self.charactersVM titleForCharacterId:self.characterId];
}


- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isBackButtonVisible {
    return YES;
}

#pragma mark - FavoriteButtonPressed 

- (void)favoriteButtonPressed:(FavoriteButton*)button {
    [self.charactersVM changeFavoriteSateForCharacterWithId:self.characterId];
    BOOL isFavoriteCharacter = [self.charactersVM isFavoriteCharacterWithId:self.characterId];
    NSString *characterTitle = [self.charactersVM titleForCharacterId:self.characterId];
    NSString *toast = isFavoriteCharacter ? LOCALIZED_WITH_OBJ(@"AddedToFavorites", characterTitle) : LOCALIZED_WITH_OBJ(@"RemovedFromFavorites", characterTitle);
    [self.view makeToast:toast];

}

- (BOOL)conditionForActiveFavoriteButtonImage {
    return [self.charactersVM isFavoriteCharacterWithId:self.characterId];
}

@end
