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
#import "AccountMO+CoreDataClass.h"

@interface FavoriteViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray<Movie *> * movies;

@property (nonatomic) BOOL isFirstReload;

@property (nonatomic) Account * account;

@property (nonatomic) BOOL isSearchAction;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstReload = YES;
    
    self.movies = [[NSMutableArray alloc] init];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerEventTapView)];
    [self.view addGestureRecognizer: tapGestureRecognizer];
    
    [self.tableView registerNib:[UINib nibWithNibName:MOVIE_ITEM_CELL bundle:nil] forCellReuseIdentifier:MOVIE_ITEM_CELL];
}

- (void) handlerEventTapView {
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.account = [[AccountManager getInstance] account];
    if(self.account) {
        [self setMoviesWithSet: self.account.favouriteMovies];
    }
    if(!self.isFirstReload) {
        [self.tableView reloadData];
    }
    else {
        self.isFirstReload = NO;
    }
    self.isSearchAction = NO;
}

- (void) setMoviesWithSet: (NSSet *)sets {
    [self.movies removeAllObjects];
    for(id item in sets) {
        [self.movies addObject: item];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.account) {
        // update list favourite movie of account
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(myQueue, ^{
            [AccountMO updateAccount: self.account];
        });
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
    [cell setMovieItemCell:[self.movies objectAtIndex: indexPath.row]];
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        __weak FavoriteViewController * weakSelf = self;
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"❓❓❓" message:@"Are you sure you want to remove this item from favourite?" preferredStyle: UIAlertControllerStyleAlert];
        [alertController addAction: [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            Movie * movie = [weakSelf.movies objectAtIndex: indexPath.row];
            [weakSelf.movies removeObject: movie];
            [weakSelf.account.favouriteMovies removeObject: movie];
            [weakSelf.tableView reloadData];
        }]];
        [alertController addAction: [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark <UITableViewDelegate>

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isSearchAction) {
        cell.layer.opacity = 0.5;
        __block CGRect frameOfCell = cell.frame;
        frameOfCell.origin.y += 50;
        cell.frame = frameOfCell;
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            frameOfCell.origin.y -= 50;
            cell.frame = frameOfCell;
            cell.layer.opacity = 1.0;
        } completion:nil];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    NSString * format = [NSString stringWithFormat:@"'%@%@%@'", @"*", searchBar.text, @"*"];
    if(self.account) {
        if(self.account.favouriteMovies) {
            NSSet<Movie *> * sets = [self.account.favouriteMovies filteredSetUsingPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"SELF.title LIKE[c] %@", format]]];
            if(sets) {
                [self setMoviesWithSet: sets];
                self.isSearchAction = YES;
                [self.tableView reloadData];
            }
        }
    }
}

@end
