#import "TableViewCreator.h"
#import "MovieItemCell.h"
#import "Constants.h"
#import "DetailViewController.h"
#import "IndicatorTableViewCell.h"

@interface TableViewCreator()

@property (nonatomic) UITableView * tableView;
@property (nonatomic) UIStoryboard * mainStoryBoard;

@end

@implementation TableViewCreator

#pragma mark <UITableViewDataSource>

- (instancetype) initWithTableView: (UITableView *)tableView {
    self = [super init];
    if(self) {
        self.tableView = tableView;
        self.mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.tableView registerNib:[UINib nibWithNibName:MOVIE_ITEM_CELL bundle:nil] forCellReuseIdentifier:MOVIE_ITEM_CELL];
        [self.tableView registerNib:[UINib nibWithNibName:INDICATOR_TABLE_VIEW_CELL bundle:nil] forCellReuseIdentifier:INDICATOR_TABLE_VIEW_CELL];
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1 && self.tableView.loadingData) {
        return 1;
    }
    else if(section == 1) {
        return 0;
    }
    else if(section == 0) {
        return tableView.movies.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        MovieItemCell * cell = [tableView dequeueReusableCellWithIdentifier: MOVIE_ITEM_CELL forIndexPath:indexPath];
        [cell setMovieItemCell:[self.tableView.movies objectAtIndex: indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    else {
        IndicatorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: INDICATOR_TABLE_VIEW_CELL];
        [cell startIndicatorActivity];
        return cell;
    }
}

#pragma mark <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController * detailViewController = [self.mainStoryBoard instantiateViewControllerWithIdentifier: DETAIL_VIEW_CONTROLLER_MAIN_STORYBOARD];
    detailViewController.movie = [tableView.movies objectAtIndex:indexPath.row];
    detailViewController.delegate = self;
    [self.delegate pushDetailViewController:detailViewController];
}

#pragma mark <UIScrollViewDelegate>

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    float yOfTableView = scrollView.contentOffset.y;
    float heightOfContentSize = scrollView.contentSize.height;
    float z = heightOfContentSize - CGRectGetHeight(scrollView.frame);
    if(yOfTableView >= z && z >= 0) {
        if(!self.tableView.loadingData) {
            [self beginLoadData];
        }
    }
}

- (void) beginLoadData {
    self.tableView.loadingData = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex: 1] withRowAnimation:UITableViewRowAnimationNone];
    [self performSelector:@selector(loading) withObject:nil afterDelay:1.0];
}

- (void) loading {
    [self.delegate loadMore];
}

#pragma mark <MovieItemCellDelegate, DetailViewControllerDelegate>

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
