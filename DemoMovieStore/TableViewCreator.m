//
//  TableViewCreator.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "TableViewCreator.h"
#import "MovieItemCell.h"
#import "Constants.h"
#import "DetailViewController.h"

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
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieItemCell * cell = [tableView dequeueReusableCellWithIdentifier: MOVIE_ITEM_CELL forIndexPath:indexPath];
    [cell setMovieItemCell:[self.tableView.movies objectAtIndex: indexPath.row]];
    cell.delegate = self;
    return cell;
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

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == self.tableView.movies.count - 1) {
        [self.delegate loadMore];
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

@end
