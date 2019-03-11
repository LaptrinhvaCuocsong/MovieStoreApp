#import "TableViewCreator.h"
#import "MovieItemCell.h"
#import "Constants.h"
#import "DetailViewController.h"

@interface TableViewCreator()

@property (nonatomic) UITableView * tableView;
@property (nonatomic) UIStoryboard * mainStoryBoard;
@property (nonatomic) BOOL loadMore;

@end

@implementation TableViewCreator

#pragma mark <UITableViewDataSource>

- (instancetype) initWithTableView: (UITableView *)tableView {
    self = [super init];
    if(self) {
        self.tableView = tableView;
        self.loadMore = NO;
        self.mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.tableView registerNib:[UINib nibWithNibName:MOVIE_ITEM_CELL bundle:nil] forCellReuseIdentifier:MOVIE_ITEM_CELL];
        [self.tableView registerNib:[UINib nibWithNibName:INDICATOR_VIEW_CELL bundle:nil] forCellReuseIdentifier:INDICATOR_VIEW_CELL];
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1 && self.loadMore) {
        return 1;
    }
    return tableView.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        MovieItemCell * cell = [tableView dequeueReusableCellWithIdentifier: MOVIE_ITEM_CELL forIndexPath:indexPath];
        [cell setMovieItemCell:[self.tableView.movies objectAtIndex: indexPath.row]];
        cell.delegate = self;
        return cell;
    }
    else {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: INDICATOR_VIEW_CELL];
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
    float contentSize = scrollView.contentSize.height;
    float z = contentSize - CGRectGetHeight(scrollView.frame);
    if(z >= 0) {
        if(yOfTableView >= z) {
            self.loadMore = YES;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else {
        self.loadMore = NO;
    }
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
