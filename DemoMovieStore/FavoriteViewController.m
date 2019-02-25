//
//  FavoriteViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "FavoriteViewController.h"
#import "Movie.h"
#import "AccountManager.h"
#import "MovieItemCell.h"
#import "Constants.h"

@interface FavoriteViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSMutableArray<Movie *> * movies;

@property (nonatomic) NSMutableArray * arrayImageURLString;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movies = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.arrayImageURLString = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:MOVIE_ITEM_CELL bundle:nil] forCellReuseIdentifier:MOVIE_ITEM_CELL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Account * account = [[AccountManager getInstance] account];
    if(account) {
        if(account.favouriteMovies) {
            for(id item in account.favouriteMovies) {
                [self.movies addObject: item];
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    Account * account = [[AccountManager getInstance] account];
    if(account) {
        if(self.movies.count > 0) {
            account.favouriteMovies = [[NSMutableSet alloc] initWithArray: self.movies];
        }
    }
}

#pragma mark <UITableViewDataSource>

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieItemCell * cell = [tableView dequeueReusableCellWithIdentifier:MOVIE_ITEM_CELL forIndexPath:indexPath];
    if(self.arrayImageURLString.count < (indexPath.row + 1)) {
        [cell setMovieItemCell:[self.movies objectAtIndex: indexPath.row] imageURLString:nil arrayImageURLString:self.arrayImageURLString];
    }
    else {
        NSString * imageURLString = [self.arrayImageURLString objectAtIndex: indexPath.row];
        [cell setMovieItemCell:[self.movies objectAtIndex: indexPath.row] imageURLString:imageURLString arrayImageURLString:self.arrayImageURLString];
    }
    return cell;
}

@end
