//
//  CharacterCell.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 28/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "CharacterCell.h"
#import <Masonry.h>
#import "Consts.h"
#import "UIColor+AdditionalColors.h"
#import "UITableViewCell+SelectedColor.h"

@interface CharacterCell() <FavoriteButtonDelegate>
@property (strong, nonatomic) UIImageView *thumbnailImageView;
@property (strong, nonatomic) UIActivityIndicatorView *thumbnailIndicator;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *abstractLabel;
@property (strong, nonatomic) FavoriteButton *favoriteButton;

@property (strong, nonatomic) CharactersViewModel *charactersVM;
@property (nonatomic) NSInteger characterId;

@end

@implementation CharacterCell
@synthesize reuseIdentifier = _characterCellReuseIdentifier;

- (instancetype)initWithCharactersViewModel:(CharactersViewModel *)charactersVM andDelegate:(id<CharacterCellDelegate>)delegate {
    self = [super init];
    if (self) {
        self.charactersVM = charactersVM;
        self.delegate = delegate;
        self.reuseIdentifier = CHARACTER_CELL_ID;
        self.backgroundColor = [UIColor clearColor];
        [self setSelectedColor:[UIColor cellSelectedColor]];
        
        [self initThumbnailImageView];
        [self initThumbnailIndicator];
        [self initFavoriteButton];
        [self initTitleLabel];
        [self initAbstractLabel];
    }
    return self;
}

- (void)initThumbnailImageView {
    self.thumbnailImageView = [UIImageView new];
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.thumbnailImageView.layer.cornerRadius = THUMBNAIL_SIZE / 4;
    self.thumbnailImageView.layer.masksToBounds = YES;
    
    [self addSubview:self.thumbnailImageView];
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(DEFAULT_OFFSET);
        make.leading.equalTo(self.mas_leading).with.offset(DEFAULT_OFFSET);
        make.width.equalTo(@(THUMBNAIL_SIZE));
        make.height.equalTo(@(THUMBNAIL_SIZE));
    }];
}

- (void)initThumbnailIndicator {
    self.thumbnailIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.thumbnailIndicator.hidesWhenStopped = YES;
    [self.thumbnailIndicator startAnimating];
    
    [self addSubview:self.thumbnailIndicator];
    [self.thumbnailIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.thumbnailImageView.mas_centerX);
        make.centerY.equalTo(self.thumbnailImageView.mas_centerY);
    }];
}

- (void)initFavoriteButton {
    self.favoriteButton = [[FavoriteButton alloc] initWithDelegate:self];
    [self addSubview:self.favoriteButton];
    
    [self.favoriteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.thumbnailImageView.mas_centerY);
        make.trailing.equalTo(self.mas_trailing);
        make.width.equalTo(@(FAVORITE_BUTTON_SIZE));
        make.height.equalTo(@(FAVORITE_BUTTON_SIZE));
    }];
}

- (void)initTitleLabel {
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.thumbnailImageView.mas_centerY);
        make.leading.equalTo(self.thumbnailImageView.mas_trailing).with.offset(DEFAULT_OFFSET);
        make.trailing.equalTo(self.favoriteButton.mas_leading);
    }];
}

- (void)initAbstractLabel {
    self.abstractLabel = [UILabel new];
    self.abstractLabel.numberOfLines = 2;
    self.abstractLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.abstractLabel.font = [UIFont systemFontOfSize:14];
    self.abstractLabel.textColor = [UIColor grayColor];
    
    [self addSubview:self.abstractLabel];
    [self.abstractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.thumbnailImageView.mas_trailing).with.offset(DEFAULT_OFFSET);
        make.trailing.equalTo(self.favoriteButton.mas_leading);
        make.top.equalTo(self.titleLabel.mas_top).with.offset(DEFAULT_OFFSET);
    }];
}

- (void)fillWithCharacterId:(NSInteger)characterId {
    self.characterId  = characterId;
    UIImage *thumbnailImage = [self.charactersVM imageForCharacterId:characterId];
    if (thumbnailImage) {
        self.thumbnailImageView.image = thumbnailImage;
        [self.thumbnailIndicator stopAnimating];
    } else {
        [self.thumbnailImageView startAnimating];
    }
    self.titleLabel.text = [self.charactersVM titleForCharacterId:characterId];
    self.abstractLabel.text = [self.charactersVM abstarctForCharacterId:characterId];
    [self.favoriteButton setImageDependingOnButtonState:[self.charactersVM isFavoriteCharacterWithId:characterId]];
}

- (CGFloat)getExpandedHeight {
    self.abstractLabel.numberOfLines = 0;
    [self.abstractLabel sizeToFit];
    return self.abstractLabel.frame.size.height + self.titleLabel.frame.size.height + DEFAULT_OFFSET * 2;
}

- (void)shrinkAbstractLabel {
    self.abstractLabel.numberOfLines = 2;
}

#pragma mark - FavoriteButtonDelegate 

- (void)favoriteButtonPressed:(FavoriteButton*)button {
    [self.delegate cell:self favoriteButtonPressed:button withCharacterId:self.characterId];
}

- (BOOL)conditionForActiveFavoriteButtonImage {
    return [self.charactersVM isFavoriteCharacterWithId:self.characterId];
}

@end
