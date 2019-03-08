#import "CollectionViewCreator.h"
#import "UICollectionView+Extent.h"
#import "Constants.h"
#import "MovieCollectionViewCell.h"
#import "DetailViewController.h"

@interface CollectionViewCreator()

@property (nonatomic) UICollectionView * collectionView;

@end

@implementation CollectionViewCreator

- (instancetype) initWithCollectionView: (UICollectionView *)collectionView {
    self = [super init];
    if(self) {
        self.collectionView = collectionView;
        [self.collectionView registerNib:[UINib nibWithNibName:MOVIE_COLLECTION_VIEW_CELL bundle:nil] forCellWithReuseIdentifier:MOVIE_COLLECTION_VIEW_CELL];
    }
    return self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOVIE_COLLECTION_VIEW_CELL forIndexPath:indexPath];
    [cell setMovieCollectionViewCell: [collectionView.movies objectAtIndex: indexPath.item]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:
    (NSIndexPath *)indexPath {
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController * detailViewController = [mainStoryboard instantiateViewControllerWithIdentifier: DETAIL_VIEW_CONTROLLER_MAIN_STORYBOARD];
    detailViewController.movie = [collectionView.movies objectAtIndex: indexPath.item];
    detailViewController.delegate = self;
    [self.delegate pushDetailViewController: detailViewController];
}

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item == self.collectionView.movies.count-1) {
        [self.delegate loadMore];
    }
}

#pragma mark <DetailViewControllerDelegate>

- (void) addOrRemoveFavouriteMovie:(Movie *)movie {
    [self.delegate addOrRemoveFavouriteMovie: movie];
}

- (void) addOrSetReminderMovie:(Reminder *)reminder {
    [self.delegate addOrSetReminderMovie: reminder];
}

- (BOOL) isGranted {
    return [self.delegate isGranted];
}

- (Reminder *) reminderWithMovieId: (NSInteger)movieId {
    return [self.delegate reminderWithMovieId: movieId];
}

- (BOOL) checkFavouriteMovie:(Movie *)movie {
    return [self.delegate checkFavouriteMovie:movie];
}

@end
