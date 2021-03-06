#import "MovieListViewController.h"
#import "TableViewCreator.h"
#import "CollectionViewCreator.h"
#import "Movie.h"
#import "MoviesCreator.h"
#import "Constants.h"
#import "MoviesCreatorImpl.h"
#import "UICollectionView+Extent.h"
#import "UITableView+Extent.h"
#import "CustomCollectionViewLayout.h"
#import "AccountManager.h"
#import "AccountMO+CoreDataClass.h"
#import "NSMutableDictionary+SettingOfAccount.h"
#import "DateUtils.h"
#import "EditProfileViewController.h"
#import "SWRevealViewController.h"

@interface MovieListViewController ()

@property (weak, nonatomic) IBOutlet UIView *movieListView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnChangeMovieListView;

@property (nonatomic) TableViewCreator * tableViewCreator;
@property (nonatomic) CollectionViewCreator * collectionViewCreator;
@property (nonatomic) UITableView * tableView;
@property (nonatomic) UICollectionView * collectionView;
@property (nonatomic) NSMutableArray<Movie *> * movies;
@property (nonatomic) CGRect frameOfMovieListView;
@property (nonatomic) UIAlertController * alertViewController;
@property (nonatomic) UIAlertController * alertErrorViewController;
@property (nonatomic) id<MoviesCreator> moviesCreator;
@property (nonatomic) __block NSUInteger pageNumber;
@property (nonatomic) Account * account;
@property (nonatomic) NSMutableDictionary * settingOfAccount;
@property (nonatomic) BOOL isFirstReload;
@property (nonatomic) NSString * currentURLString;
@property (nonatomic) BOOL alertIsActive;
@property (nonatomic) NSInteger currentTime;
@property (nonatomic) NSTimer * timer;
@property (nonatomic) BOOL timerIsActive;

@end

typedef NS_ENUM(NSInteger, MOVIE_LIST_TYPE) {
    TABLE_VIEW = 0
    , COLLECTION_VIEW
};

@implementation MovieListViewController

static const NSInteger MAX_TIME_OUT = 8;

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.timerIsActive = NO;
    self.currentTime = MAX_TIME_OUT;
    self.alertIsActive = NO;
    self.isFirstReload = YES;
    self.pageNumber = 1;
    self.frameOfMovieListView = self.movieListView.frame;
    self.moviesCreator = [[MoviesCreatorImpl alloc] init];
    self.movies = [[NSMutableArray alloc] init];
    [self setSubViewForMovieListView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerEventChangeSetting) name:DID_CHANGE_SETTING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerEventChangeAccount) name:DID_SAVE_ACCOUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerEventChangeAccount) name:DID_REMOVE_ACCOUNT object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.account = [[AccountManager getInstance] account];
    if(self.isFirstReload) {
        self.isFirstReload = NO;
    }
    else {
        [self reloadViewWhenChangeAccount];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    if(self.movies.count == 0) {
        self.settingOfAccount = [[AccountManager getInstance] settingOfAccount];
        if(self.settingOfAccount) {
            self.currentURLString = [self.settingOfAccount urlString];
        }
        else {
            self.currentURLString = API_GET_MOVIE_POPULAR_LIST;
        }
        [self fetchMoviesFromAPI: self.currentURLString];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) setFavouriteForMovies: (NSMutableArray *)movies {
    for(Movie * movie in movies) {
        BOOL exist = NO;
        for(Movie * favouriteMovie in self.account.favouriteMovies) {
            if(movie.identifier == favouriteMovie.identifier) {
                exist = YES;
                break;
            }
        }
        if(exist) {
            movie.isFavouriteMovie = YES;
        }
        else {
            movie.isFavouriteMovie = NO;
        }
    }
}

- (void) reloadViewWhenChangeAccount {
    if(self.movieListView.subviews) {
        if(self.account) {
            [self setFavouriteForMovies: self.movies];
        }
        else {
            for(Movie * item in self.movies) {
                item.isFavouriteMovie = NO;
            }
        }
        id subView = [self.movieListView.subviews firstObject];
        [subView setMovies: self.movies];
        [subView reloadData];
    }
}

- (void) handlerEventChangeAccount {
    self.account = [[AccountManager getInstance] account];
    [self reloadViewWhenChangeAccount];
}

- (UITableView *) tableView {
    if(!_tableView) {
        CGRect frameOfTableView = self.frameOfMovieListView;
        frameOfTableView.origin.y = 0;
        _tableView = [[UITableView alloc] initWithFrame:frameOfTableView style:UITableViewStylePlain];
        
        self.tableViewCreator = [[TableViewCreator alloc] initWithTableView: _tableView];
        self.tableViewCreator.delegate = self;
        
        _tableView.delegate = self.tableViewCreator;
        _tableView.dataSource = self.tableViewCreator;
        _tableView.movies = self.movies;
        
        _tableView.refreshControl = [[UIRefreshControl alloc] init];
        [_tableView.refreshControl addTarget:self action:@selector(handlerRefreshControl) forControlEvents:UIControlEventValueChanged];
    }
    else {
        _tableView.movies = self.movies;
    }
    return _tableView;
}

- (UICollectionView *) collectionView {
    if(!_collectionView) {
        CustomCollectionViewLayout * customCollectionViewLayout = [[CustomCollectionViewLayout alloc] init];
        CGRect frameOfCollectionView = self.frameOfMovieListView;
        frameOfCollectionView.origin.y = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:frameOfCollectionView collectionViewLayout:customCollectionViewLayout];
        
        self.collectionViewCreator = [[CollectionViewCreator alloc] initWithCollectionView: _collectionView];
        self.collectionViewCreator.delegate = self;
        
        _collectionView.delegate = self.collectionViewCreator;
        _collectionView.dataSource = self.collectionViewCreator;
        _collectionView.movies = self.movies;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.refreshControl = [[UIRefreshControl alloc] init];
        [_collectionView.refreshControl addTarget:self action:@selector(handlerRefreshControl) forControlEvents:UIControlEventValueChanged];
    }
    else {
        _collectionView.movies = self.movies;
    }
    return _collectionView;
}

- (void) handlerRefreshControl {
    id subView = [self.movieListView.subviews firstObject];
    [[subView refreshControl] beginRefreshing];
    [self.movies removeAllObjects];
    self.pageNumber = 1;
    [self fetchMoviesFromAPIForRefresh: self.currentURLString];
}

- (UIAlertController *) alertViewController {
    if(!_alertViewController) {
        _alertViewController = [UIAlertController alertControllerWithTitle:@"" message:@"Waiting ..." preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        CGRect frameOfActivity = activityIndicator.frame;
        frameOfActivity.origin.x = 25;
        frameOfActivity.origin.y = 17.5;
        activityIndicator.frame = frameOfActivity;
        [_alertViewController.view addSubview: activityIndicator];
        [activityIndicator startAnimating];
    }
    return _alertViewController;
}

- (void) dismissAlertViewController: (BOOL)animated completion: (void(^)(void))completion {
    [self dismissViewControllerAnimated:animated completion:completion];
}

- (void) addConstraintForMovieListView: (UIView *)subView {
    [subView setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self.movieListView addConstraint: [NSLayoutConstraint constraintWithItem:self.movieListView
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:subView
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    
    [self.movieListView addConstraint: [NSLayoutConstraint constraintWithItem:self.movieListView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:subView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    
    [self.movieListView addConstraint: [NSLayoutConstraint constraintWithItem: self.movieListView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:subView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0
                                                                       constant:0.0]];
    
    [self.movieListView addConstraint: [NSLayoutConstraint constraintWithItem: self.movieListView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:subView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0.0]];
}

- (void) setSubViewForMovieListView {
    NSArray<__kindof UIView *> * subViews = self.movieListView.subviews;
    if(!subViews || subViews.count == 0) {
        [self.movieListView addSubview: self.tableView];
        [self addConstraintForMovieListView: self.tableView];
        [self setImageButtonChangeMovieList: TABLE_VIEW];
    }
    else {
        UIView * firstView = [subViews firstObject];
        if([firstView isKindOfClass: [UITableView class]]) {
            [self.tableView removeFromSuperview];
            [self.movieListView addSubview: self.collectionView];
            [self addConstraintForMovieListView: self.collectionView];
            [self setImageButtonChangeMovieList: COLLECTION_VIEW];
            [self.collectionView reloadData];
        }
        else {
            [self.collectionView removeFromSuperview];
            [self.movieListView addSubview: self.tableView];
            [self addConstraintForMovieListView: self.tableView];
            [self setImageButtonChangeMovieList: TABLE_VIEW];
            [self.tableView reloadData];
        }
    }
}

- (IBAction)changeMovieListView:(id)sender {
    [self setSubViewForMovieListView];
}

- (void) setImageButtonChangeMovieList: (MOVIE_LIST_TYPE)currentMovieListType {
    switch (currentMovieListType) {
        case TABLE_VIEW:
            self.btnChangeMovieListView.image = [UIImage imageNamed:@"ic_view_module"];
            break;
        default:
            self.btnChangeMovieListView.image = [UIImage imageNamed:@"ic_list"];
            break;
    }
}

#pragma mark <Setup Data>

- (void) startCountDown {
    @synchronized (self) {
        if(!self.timerIsActive) {
            __weak MovieListViewController * weakSelf = self;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                weakSelf.currentTime -= 1;
            }];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            self.timerIsActive = YES;
        }
    }
}

- (void) stopCountDown {
    @synchronized (self) {
        if(self.timerIsActive) {
            [self.timer invalidate];
            self.timerIsActive = NO;
            self.currentTime = MAX_TIME_OUT;
        }
    }
}

- (void) reloadDataWhenFetchMoviesFinish {
    id subview = [self.movieListView.subviews firstObject];
    [subview setMovies: self.movies];
    [subview reloadData];
    if(self.alertIsActive) {
        [self dismissViewControllerAnimated:NO completion:nil];
        self.alertIsActive = NO;
    }
    [self stopCountDown];
}

- (void) fetchMoviesFromAPI: (NSString *)urlString {
    if(!self.alertIsActive) {
        self.alertIsActive = YES;
        [self presentViewController:self.alertViewController animated:YES completion:nil];
    }
    [self startCountDown];
    __weak MovieListViewController * weakSelf = self;
    if(self.currentTime >= 0) {
        NSInteger limitMovieOfView = 20;
        [self.moviesCreator createMoviesWithPageNumber:self.pageNumber success:^(NSMutableArray<Movie *> * _Nonnull movies, NSInteger totalPages) {
            [weakSelf setMoviesWithMovieRate: movies];
            [weakSelf setMoviesWithMovieReleaseYear: movies];
            if(weakSelf.account) {
                [weakSelf setFavouriteForMovies: movies];
            }
            [weakSelf.movies addObjectsFromArray: [NSArray arrayWithArray: movies]];
            if(weakSelf.movies.count < limitMovieOfView && weakSelf.pageNumber < totalPages) {
                weakSelf.pageNumber ++;
                [weakSelf fetchMoviesFromAPI: urlString];
            }
            else {
                [weakSelf sortMoiveWithTypeOfSort: weakSelf.movies];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf reloadDataWhenFetchMoviesFinish];
                });
            }
        } failure:^{
            [weakSelf handlerErrorWhenFetchAPI: urlString];
            [weakSelf stopCountDown];
        } urlString:urlString];
    }
    else {
        [self handlerEventTimeOut:urlString agree:^{
            [weakSelf stopCountDown];
            [weakSelf fetchMoviesFromAPI: urlString];
        } disagree:^{
            [weakSelf reloadDataWhenFetchMoviesFinish];
        }];
    }
}

- (void) reloadDataWhenFetchMoviesForRefreshFinish {
    id subview = [self.movieListView.subviews firstObject];
    [subview setMovies: self.movies];
    [subview reloadData];
    if([[subview refreshControl] isRefreshing]) {
        [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.0];
    }
    [self stopCountDown];
}

- (void) fetchMoviesFromAPIForRefresh: (NSString *)urlString {
    [self startCountDown];
    __weak MovieListViewController * weakSelf = self;
    if(self.currentTime >= 0) {
        NSInteger limitMovieOfView = 20;
        [self.moviesCreator createMoviesWithPageNumber:self.pageNumber success:^(NSMutableArray<Movie *> * _Nonnull movies, NSInteger totalPages) {
            [weakSelf setMoviesWithMovieRate: movies];
            [weakSelf setMoviesWithMovieReleaseYear: movies];
            if(weakSelf.account) {
                [weakSelf setFavouriteForMovies: movies];
            }
            [weakSelf.movies addObjectsFromArray: [NSArray arrayWithArray: movies]];
            if(weakSelf.movies.count < limitMovieOfView && weakSelf.pageNumber < totalPages) {
                weakSelf.pageNumber ++;
                [weakSelf fetchMoviesFromAPIForRefresh: urlString];
            }
            else {
                [weakSelf sortMoiveWithTypeOfSort: weakSelf.movies];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf reloadDataWhenFetchMoviesForRefreshFinish];
                });
            }
        } failure:^{
            [weakSelf handlerErrorWhenFetchAPI: urlString];
            [weakSelf stopCountDown];
        } urlString:urlString];
    }
    else {
        [self handlerEventTimeOutWhenRefresh:urlString agree:^{
            [weakSelf stopCountDown];
            [weakSelf fetchMoviesFromAPIForRefresh: urlString];
        } disagree:^{
            [weakSelf stopCountDown];
            [weakSelf reloadDataWhenFetchMoviesForRefreshFinish];
        }];
    }
}

- (void) endRefreshing {
    id subview = [self.movieListView.subviews firstObject];
    [[subview refreshControl] endRefreshing];
}

- (void) fetchMoviesFromAPIForLoadMore: (NSString *)urlString limitMovie: (NSInteger)limitMovie {
    __weak MovieListViewController * weakSelf = self;
    [self.moviesCreator createMoviesWithPageNumber:self.pageNumber success:^(NSMutableArray<Movie *> * _Nonnull movies, NSInteger totalPages) {
        [weakSelf setMoviesWithMovieRate: movies];
        [weakSelf setMoviesWithMovieReleaseYear: movies];
        if(weakSelf.account) {
            [weakSelf setFavouriteForMovies: movies];
        }
        [weakSelf.movies addObjectsFromArray: [NSArray arrayWithArray: movies]];
        if(weakSelf.movies.count < limitMovie && weakSelf.pageNumber < totalPages) {
            weakSelf.pageNumber ++;
            [weakSelf fetchMoviesFromAPIForLoadMore:urlString limitMovie:limitMovie];
        }
        else {
            [weakSelf sortMoiveWithTypeOfSort: weakSelf.movies];
            dispatch_async(dispatch_get_main_queue(), ^{
                id subview = [weakSelf.movieListView.subviews firstObject];
                [subview setMovies: weakSelf.movies];
                [subview reloadData];
                if([subview loadingData]) {
                    [subview setLoadingData: NO];
                }
            });
        }
    } failure:^{
        id subview = [self.movieListView.subviews firstObject];
        if([subview loadingData]) {
            [subview setLoadingData: NO];
        }
    } urlString:urlString];
}

- (void) handlerEventTimeOut: (NSString *)urlString agree: (void(^)(void))agreeBlock disagree: (void(^)(void))disagreeBlock {
    __weak MovieListViewController * weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.alertViewController dismissViewControllerAnimated:NO completion:^{
            weakSelf.alertErrorViewController = [UIAlertController alertControllerWithTitle:@"😭😭😭" message:@"Please waiting for searching finish ..." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(weakSelf.alertIsActive) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    weakSelf.alertIsActive = NO;
                }
                agreeBlock();
            }];
            [weakSelf.alertErrorViewController addAction: tryAgain];
            
            UIAlertAction * actionExit = [UIAlertAction actionWithTitle:@"No way" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                disagreeBlock();
            }];
            [weakSelf.alertErrorViewController addAction: actionExit];
            [weakSelf presentViewController:self.alertErrorViewController animated:YES completion:nil];
        }];
    });
}

- (void) handlerEventTimeOutWhenRefresh: (NSString *)urlString agree: (void(^)(void))agreeBlock disagree: (void(^)(void))disagreeBlock {
    __weak MovieListViewController * weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.alertErrorViewController = [UIAlertController alertControllerWithTitle:@"😭😭😭" message:@"Please waiting for searching finish ..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if(weakSelf.alertIsActive) {
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                weakSelf.alertIsActive = NO;
            }
            agreeBlock();
        }];
        [weakSelf.alertErrorViewController addAction: tryAgain];
        
        UIAlertAction * actionExit = [UIAlertAction actionWithTitle:@"No way" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            disagreeBlock();
        }];
        [weakSelf.alertErrorViewController addAction: actionExit];
        [weakSelf presentViewController:self.alertErrorViewController animated:YES completion:nil];
    });
}

- (void) handlerErrorWhenFetchAPI: (NSString *)urlString {
    __weak MovieListViewController * weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.alertViewController dismissViewControllerAnimated:NO completion: ^ {
            weakSelf.alertErrorViewController = [UIAlertController alertControllerWithTitle:@"💔💔💔" message:@"We can't load movie collection" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(weakSelf.alertIsActive) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    weakSelf.alertIsActive = NO;
                }
                weakSelf.pageNumber = 1;
                [weakSelf fetchMoviesFromAPI: urlString];
            }];
            [self.alertErrorViewController addAction: tryAgain];
            
            UIAlertAction * actionExit = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                exit(0);
            }];
            [weakSelf.alertErrorViewController addAction: actionExit];
            [weakSelf presentViewController:weakSelf.alertErrorViewController animated:YES completion:nil];
        }] ;
    });
}

- (void) setMoviesWithMovieRate: (NSMutableArray *)movies {
    float movieRate = [self.settingOfAccount movieRate];
    [movies filterUsingPredicate: [NSPredicate predicateWithFormat: @"SELF.voteAverage >= %f", movieRate]];
}

- (void) setMoviesWithMovieReleaseYear: (NSMutableArray *)movies {
    NSInteger movieReleaseYear = [self.settingOfAccount releaseYear];
    [movies filterUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        Movie * movie = (Movie *)evaluatedObject;
        NSInteger year = [DateUtils yearFromDate: movie.releaseDate];
        if(year < movieReleaseYear) {
            return NO;
        }
        return YES;
    }]];
}

- (void) sortMoiveWithTypeOfSort: (NSMutableArray *)movies {
    TYPE_OF_SORT typeOfSort = self.settingOfAccount.typeOfSort;
    if(typeOfSort == RELEASE_DATE_SORT) {
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"releaseDate" ascending: YES];
        NSArray<NSSortDescriptor *> * array = @[sortDescriptor];
        [movies sortUsingDescriptors: array];
    }
    else if(typeOfSort == RATING_SORT) {
        NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"voteAverage" ascending: YES];
        NSArray<NSSortDescriptor *> * array = @[sortDescriptor];
        [movies sortUsingDescriptors: array];
    }
}

#pragma mark <EditProfileViewControllerDelegate>

- (void) dismissProfileViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <TableViewCreatorDelegate, CollectionViewCreatorDelegate>

- (BOOL) isGranted {
    if(!self.account) {
        [self showMessageError];
        return NO;
    }
    return YES;
}

- (void) addOrRemoveFavouriteMovie:(Movie *)movie {
    if(!self.account.favouriteMovies) {
        self.account.favouriteMovies = [[NSMutableSet alloc] init];
    }
    if(movie.isFavouriteMovie) {
        [self.account.favouriteMovies addObject: movie];
    }                                                                                                                         
    else {
        Movie * m = [[self.account.favouriteMovies filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.identifier = %d", movie.identifier]] anyObject];
        if(m) {
            [self.account.favouriteMovies removeObject: m];
        }
    }
}

- (void) removeReminderMovie: (Reminder * _Nonnull)reminder {
    if(self.account.reminderMovies) {
        Reminder * r = [[self.account.reminderMovies filteredSetUsingPredicate: [NSPredicate predicateWithFormat:@"SELF.identifer = %d", reminder.identifer]] anyObject];
        if(r) {
            [self.account.reminderMovies removeObject: r];
        }
    }
}

- (void) addOrSetReminderMovie:(Reminder *)reminder {
    if(!self.account.reminderMovies) {
        self.account.reminderMovies = [[NSMutableSet alloc] init];
    }
    Reminder * r = [[self.account.reminderMovies filteredSetUsingPredicate: [NSPredicate predicateWithFormat:@"SELF.identifer = %d", reminder.identifer]] anyObject];
    if(r) {
        r.reminderDate = reminder.reminderDate;
    }
    else {
        [self.account.reminderMovies addObject: reminder];
    }
}

- (void) pushDetailViewController:(DetailViewController *)detailViewController {
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (Reminder *) reminderWithMovieId: (NSInteger)movieId {
    if(self.account) {
        if(self.account.reminderMovies) {
            for(Reminder * r in self.account.reminderMovies) {
                if(r.movie.identifier == movieId) {
                    return r;
                }
            }
        }
    }
    return nil;
}

- (BOOL) checkFavouriteMovie:(Movie *)movie {
    if(self.account) {
        if(self.account.favouriteMovies) {
            BOOL isFavoutireMovie = NO;
            for(Movie * m in self.account.favouriteMovies) {
                if(m.identifier == movie.identifier) {
                    isFavoutireMovie = YES;
                    break;
                }
            }
            if(isFavoutireMovie) {
                return YES;
            }
        }
    }
    return NO;
}

- (void) loadMore {
    self.pageNumber += 1;
    NSInteger limitMovieOfView = self.pageNumber * 20;
    [self fetchMoviesFromAPIForLoadMore:self.currentURLString limitMovie:limitMovieOfView];
}

- (void) showMessageError {
    __weak MovieListViewController * weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"🙏🙏🙏" message:@"You must be logged in to perform this feature" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Login now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditProfileViewController * editProfileViewController = [storyBoard instantiateViewControllerWithIdentifier: EDIT_PROFILE_VIEW_CONTROLLER_MAIN_STORYBOARD];
        editProfileViewController.delegate = weakSelf;
        [weakSelf presentViewController:editProfileViewController animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) handlerEventChangeSetting {
	self.pageNumber = 1;
    [self.movies removeAllObjects];
    id subView = [self.movieListView.subviews firstObject];
    [subView setContentOffset: CGPointMake(0.0, 0.0)];
}

@end
