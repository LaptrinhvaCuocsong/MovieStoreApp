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

@property (nonatomic) NSMutableArray * arrayImageURLString;

@property (nonatomic) UIStoryboard * mainStoryBoard;

@end

@implementation TableViewCreator

#pragma mark <UITableViewDataSource>

- (instancetype) initWithTableView: (UITableView *)tableView {
    self = [super init];
    if(self) {
        self.tableView = tableView;
        self.arrayImageURLString = [[NSMutableArray alloc] init];
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
    if(self.arrayImageURLString.count < (indexPath.row + 1)) {
        [cell setMovieItemCell:[self.tableView.movies objectAtIndex: indexPath.row] imageURLString:nil arrayImageURLString:self.arrayImageURLString];
    }
    else {
        NSString * imageURLString = [self.arrayImageURLString objectAtIndex: indexPath.row];
        [cell setMovieItemCell:[self.tableView.movies objectAtIndex: indexPath.row] imageURLString:imageURLString arrayImageURLString:self.arrayImageURLString];
    }
    cell.delegate = self;
    return cell;
}

#pragma mark <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController * detailViewController = [self.mainStoryBoard instantiateViewControllerWithIdentifier: DETAIL_VIEW_CONTROLLER_MAIN_STORYBOARD];
    detailViewController.movie = [tableView.movies objectAtIndex:indexPath.row];
    [self.delegate pushDetailViewController:detailViewController];
}

#pragma mark <MovieItemCellDelegate>

- (void) addOrRemoveFavouriteMovie:(Movie *)movie {
    [self.delegate addOrRemoveFavouriteMovie: movie];
}

@end
