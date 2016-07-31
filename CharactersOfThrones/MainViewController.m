//
//  MainViewController.m
//  CharactersOfThrones
//
//  Created by Adam Szczuchniak on 27/07/16.
//  Copyright © 2016 Adam Szczuchniak. All rights reserved.
//

#import "MainViewController.h"
#import "CharacterCell.h"
#import "CharactersViewModel.h"
#import "DetailsViewController.h"
#import <UIView+Toast.h>
#import "UITableView+EmptyView.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, CharactersViewModelDelegate, CharacterCellDelegate>

@property (strong, nonatomic) CharactersViewModel *charactersViewModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *expandedCellIndexPath;
@property (nonatomic) CGFloat expandedCellHeight;
@property (nonatomic) BOOL isFavoriteModeActive;

@end

@implementation MainViewController

- (void)viewDidLoad {
    self.isFavoriteModeActive = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_FAVORITE_MODE_ACTIVE] ? : NO;
    [super viewDidLoad];
    
    self.charactersViewModel = [[CharactersViewModel alloc] initWithDelegate:self];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isMovingToParentViewController) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .3;
    [self.tableView addGestureRecognizer:lpgr];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.navigationBar.mas_bottom);
    }];
}

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isFavoriteModeActive ? [self.charactersViewModel numberOfFavoriteCharacters] : [self.charactersViewModel numberOfAllCharacters];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:CHARACTER_CELL_ID];
    if (!cell) {
        cell = [[CharacterCell alloc] initWithCharactersViewModel:self.charactersViewModel andDelegate:self];
    }
   
    NSInteger characterId = [self.charactersViewModel characterIdForRow:indexPath.row isFavoriteModeActive:self.isFavoriteModeActive];
    [cell fillWithCharacterId:characterId];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.expandedCellIndexPath]) {
        return self.expandedCellHeight;
    }
    
    return CHARACTER_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger characterId = [self.charactersViewModel characterIdForRow:indexPath.row isFavoriteModeActive:self.isFavoriteModeActive];
    DetailsViewController *detailsVC = [[DetailsViewController alloc] initWithCharactersViewModel:self.charactersViewModel andCharacterId:characterId];
    [self.navigationController pushViewController:detailsVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CharacterCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.expandedCellIndexPath]) {
        self.expandedCellHeight = [cell getExpandedHeight];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(CharacterCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if([indexPath isEqual:self.expandedCellIndexPath]) {
        [cell shrinkAbstractLabel];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *selectedCellIndexPath = [self.tableView indexPathForRowAtPoint:p];
    
    if (selectedCellIndexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        BOOL isTheSameCellPressed = [selectedCellIndexPath isEqual:self.expandedCellIndexPath];

        if(self.expandedCellIndexPath) {
            CharacterCell *cell = (CharacterCell*)[self.tableView cellForRowAtIndexPath:self.expandedCellIndexPath];
            [cell shrinkAbstractLabel];
            self.expandedCellIndexPath = nil;
        }
        
        if (!isTheSameCellPressed) {
            CharacterCell *cell = (CharacterCell*)[self.tableView cellForRowAtIndexPath:selectedCellIndexPath];
            self.expandedCellIndexPath = selectedCellIndexPath;
            self.expandedCellHeight = [cell getExpandedHeight];
        }
        
        [UIView animateWithDuration:.3f animations:^{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }];
    }
}

#pragma mark - CharactersViewModelDelegate

- (void)onGetCharactersSucceed {
    [self.tableView reloadData];
}

- (void)onGetCharactersFailed {
    
}

- (void)onGetThumbnailWithCharacterId:(NSInteger)characterId {
    [self.tableView reloadData];
}

# pragma mark - CharacterCellDelegate

- (void)cell:(CharacterCell*)cell favoriteButtonPressed:(FavoriteButton *)button withCharacterId:(NSInteger)characterId{
    [self.charactersViewModel changeFavoriteSateForCharacterWithId:characterId];
    BOOL isFavoriteCharacter = [self.charactersViewModel isFavoriteCharacterWithId:characterId];
    
    if (self.isFavoriteModeActive && !isFavoriteCharacter) {
        NSIndexPath *deletedIndexPath = [self.tableView indexPathForCell:cell];
        [self.tableView deleteRowsAtIndexPaths:@[deletedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    NSString *characterTitle = [self.charactersViewModel titleForCharacterId:characterId];
    NSString *toast = isFavoriteCharacter ? LOCALIZED_WITH_OBJ(@"AddedToFavorites", characterTitle) : LOCALIZED_WITH_OBJ(@"RemovedFromFavorites", characterTitle);
    [self.view makeToast:toast];
}

#pragma mark - FavoriteButtonDelegate

- (void)favoriteButtonPressed:(FavoriteButton*)button {
    self.isFavoriteModeActive = !self.isFavoriteModeActive;
    [[NSUserDefaults standardUserDefaults] setBool:self.isFavoriteModeActive forKey:KEY_FAVORITE_MODE_ACTIVE];
    [self.tableView reloadData];
    
}

- (BOOL)conditionForActiveFavoriteButtonImage {
    return self.isFavoriteModeActive;
}

@end
