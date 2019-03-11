#import "CollectionViewCreator.h"
#import "UICollectionView+Extent.h"
#import "Constants.h"
#import "MovieCollectionViewCell.h"
#import "DetailViewController.h"
#import "IndicatorCollectionViewCell.h"

@interface CollectionViewCreator()

@property (nonatomic) UICollectionView * collectionView;

@end

@implementation CollectionViewCreator

- (instancetype) initWithCollectionView: (UICollectionView *)collectionView {
    self = [super init];
    if(self) {
        self.collectionView = collectionView;
        self.collectionView.loadingData = NO;
        [self.collectionView registerNib:[UINib nibWithNibName:MOVIE_COLLECTION_VIEW_CELL bundle:nil] forCellWithReuseIdentifier:MOVIE_COLLECTION_VIEW_CELL];
        [self.collectionView registerNib:[UINib nibWithNibName:INDICATOR_COLLECTION_VIEW_CELL bundle:nil] forCellWithReuseIdentifier:INDICATOR_COLLECTION_VIEW_CELL];
    }
    return self;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 1 && self.collectionView.loadingData) {
        return 1;
    }
    else if(section == 1) {
        return 0;
    }
    else if(section == 0) {
        return collectionView.movies.count;
    }
    else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        MovieCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MOVIE_COLLECTION_VIEW_CELL forIndexPath:indexPath];
        [cell setMovieCollectionViewCell: [collectionView.movies objectAtIndex: indexPath.item]];
        return cell;
    }
    else {
        IndicatorCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:INDICATOR_COLLECTION_VIEW_CELL forIndexPath:indexPath];
        [cell startIndicatorActivity];
        return cell;
    }
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

#pragma mark <UIScrollViewDelegate>

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    float yOfCollectionView = scrollView.contentOffset.y;
    float heightOfContentSize = scrollView.contentSize.height;
    float z = heightOfContentSize - CGRectGetHeight(self.collectionView.frame);
    if(yOfCollectionView >= z && z >= 0) {
        if(!self.collectionView.loadingData) {
            [self beginFetchData];
        }
    }
}

- (void) beginFetchData {
    self.collectionView.loadingData = YES;
    [self.collectionView reloadSections: [NSIndexSet indexSetWithIndex: 1]];
    [self performSelector:@selector(loading) withObject:nil afterDelay:1.0];
}

- (void) loading {
    [self.delegate loadMore];
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

- (void) removeReminderMovie:(Reminder *)reminder {
    [self.delegate removeReminderMovie: reminder];
}

@end
