#import "FavoriteViewController.h"
#import "Movie.h"
#import "AccountManager.h"
#import "MovieItemCell.h"
#import "Constants.h"
#import "AccountMO+CoreDataClass.h"
#import "AccountManager.h"

@interface FavoriteViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray<Movie *> * movies;
@property (nonatomic) BOOL isFirstReload;
@property (nonatomic) Account * account;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstReload = YES;
    self.movies = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerEventTapView)];
    [self.view addGestureRecognizer: tapGestureRecognizer];
    
    [self.tableView registerNib:[UINib nibWithNibName:MOVIE_ITEM_CELL bundle:nil] forCellReuseIdentifier:MOVIE_ITEM_CELL];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.account = [[AccountManager getInstance] account];
    if(self.account && self.account.favouriteMovies) {
        [self setMoviesWithSet: self.account.favouriteMovies];
    }
    if(!self.isFirstReload) {
        [self.tableView reloadData];
    }
    else {
        self.isFirstReload = NO;
    }
}

- (void) handlerEventTapView {
    [self.searchBar resignFirstResponder];
}

- (void) setMoviesWithSet: (NSSet *)sets {
    [self.movies removeAllObjects];
    [self.movies addObjectsFromArray: [sets allObjects]];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark <UISearchBarDelegate>

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString * format = [NSString stringWithFormat:@"'%@%@%@'", @"*", searchBar.text, @"*"];
    if(self.account && self.account.favouriteMovies) {
        NSSet<Movie *> * sets = [self.account.favouriteMovies filteredSetUsingPredicate: [NSPredicate predicateWithFormat: [NSString stringWithFormat:@"SELF.title LIKE[c] %@", format]]];
        if(sets) {
            [self setMoviesWithSet: sets];
            [self.tableView reloadData];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    if(self.account && self.account.favouriteMovies) {
        [self setMoviesWithSet: self.account.favouriteMovies];
        [self.tableView reloadData];
    }
    
}

@end
