//
//  MovieListViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

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

@end

typedef NS_ENUM(NSInteger, MOVIE_LIST_TYPE) {
    TABLE_VIEW = 0
    , COLLECTION_VIEW
};

@implementation MovieListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstReload = YES;
    
    self.pageNumber = 1;
    
    self.frameOfMovieListView = self.movieListView.frame;
    
    self.moviesCreator = [[MoviesCreatorImpl alloc] init];
    
    self.movies = [[NSMutableArray alloc] init];
    
    [self setSubViewForMovieListView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMovieList) name:DID_CHANGE_SETTING object:nil];
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
        
        [self excuteGetMovieFromAPI: self.currentURLString showAlert:YES];
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) reloadViewWhenChangeAccount {
    if(self.movieListView.subviews) {
        if(self.account) {
            if(self.account.favouriteMovies) {
                for(Movie * movie in self.movies) {
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
        
        // chua auto layout cho collectionView
        _collectionView.delegate = self.collectionViewCreator;
        _collectionView.dataSource = self.collectionViewCreator;
        _collectionView.movies = self.movies;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.refreshControl = [[UIRefreshControl alloc] init];
        [_collectionView.refreshControl addTarget:self action:@selector(handlerRefreshControl) forControlEvents:UIControlEventValueChanged];
    }
    return _collectionView;
}

- (void) handlerRefreshControl {
    id subView = [self.movieListView.subviews firstObject];
    [[subView refreshControl] beginRefreshing];
    [self.movies removeAllObjects];
    [self excuteGetMovieFromAPI: self.currentURLString showAlert:NO];
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
        }
        else {
            [self.collectionView removeFromSuperview];
            [self.movieListView addSubview: self.tableView];
            [self addConstraintForMovieListView: self.tableView];
            [self setImageButtonChangeMovieList: TABLE_VIEW];
        }
    }
}

- (void) excuteGetMovieFromAPI: (NSString *)urlString showAlert: (BOOL)showAlert {
    if(showAlert) {
        [self presentViewController:self.alertViewController animated:YES completion:nil];
    }
    
    NSInteger limitMovieOfView = self.pageNumber * 20;
    
    __weak MovieListViewController * weakSelf = self;
    
    [self.moviesCreator createMoviesWithPageNumber:self.pageNumber success:^(NSMutableArray<Movie *> * _Nonnull movies, NSInteger totalPages) {
        
        [weakSelf setMoviesWithMovieRate: movies];
        
        [weakSelf setMoviesWithMovieReleaseYear: movies];
        
        [weakSelf.movies addObjectsFromArray: [NSArray arrayWithArray: movies]];
        
        // set isFavouriteMovie
        if(weakSelf.account) {
            if(weakSelf.account.favouriteMovies) {
                for(Movie * movie in weakSelf.movies) {
                    BOOL exist = NO;
                    for(Movie * favouriteMovie in weakSelf.account.favouriteMovies) {
                        if(movie.identifier == favouriteMovie.identifier) {
                            exist = YES;
                            break;
                        }
                    }
                    if(exist) {
                        movie.isFavouriteMovie = YES;
                    }
                }
            }
        }
        
        if(weakSelf.movies.count < limitMovieOfView && weakSelf.pageNumber < totalPages) {
            weakSelf.pageNumber ++;
            [weakSelf excuteGetMovieFromAPI: urlString showAlert:NO];
        }
        else {
            if(weakSelf.movies.count > limitMovieOfView) {
                NSRange range = NSMakeRange(limitMovieOfView - 1, weakSelf.movies.count - limitMovieOfView);
                [weakSelf.movies removeObjectsInRange: range];
            }
            
            [weakSelf sortMoiveWithTypeOfSort: weakSelf.movies];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                id subview = [weakSelf.movieListView.subviews firstObject];
                [subview setMovies: weakSelf.movies];
                [subview reloadData];
                
                if(showAlert) {
                    [weakSelf.alertViewController dismissViewControllerAnimated:NO completion:nil];
                }
                
                if([[subview refreshControl] isRefreshing]) {
                    [[subview refreshControl] endRefreshing];
                }
                
            });
        }
        
    } failure:^{
        [weakSelf handlerErrorWhenConnectAPI: urlString];
    } urlString:urlString];
}

- (void) handlerErrorWhenConnectAPI: (NSString *)urlString {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.alertViewController dismissViewControllerAnimated:NO completion: ^ {
            if(!self.alertErrorViewController) {
                self.alertErrorViewController = [UIAlertController alertControllerWithTitle:@"💔💔💔" message:@"We can't load movie collection" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                    [self excuteGetMovieFromAPI: urlString showAlert:YES];
                }];
                [self.alertErrorViewController addAction: tryAgain];
                
                UIAlertAction * actionExit = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    exit(0);
                }];
                [self.alertErrorViewController addAction: actionExit];
            }
            [self presentViewController:self.alertErrorViewController animated:YES completion:nil];
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
    [self excuteGetMovieFromAPI:self.currentURLString showAlert:NO];
}

- (void) showMessageError {
    __weak MovieListViewController * weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"🙏🙏🙏" message:@"You must be logged in to perform this feature" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Login now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditProfileViewController * editProfileViewController = [storyBoard instantiateViewControllerWithIdentifier: EDIT_PROFILE_VIEW_CONTROLLER_MAIN_STORYBOARD];
        [weakSelf presentViewController:editProfileViewController animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) changeMovieList {
    [self.movies removeAllObjects];
}

@end
