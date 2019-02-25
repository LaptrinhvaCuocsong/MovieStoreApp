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

@property (nonatomic) UIActivityIndicatorView * activityIndicator;

@property (nonatomic) id<MoviesCreator> moviesCreator;

@property (nonatomic) NSUInteger pageNumber;

@property (nonatomic) BOOL alertViewControllerIsActive;

@property (nonatomic) Account * account;

@end

typedef NS_ENUM(NSInteger, MOVIE_LIST_TYPE) {
    TABLE_VIEW = 0
    , COLLECTION_VIEW
};

@implementation MovieListViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.alertViewControllerIsActive = NO;
    
    self.pageNumber = 1;
    
    self.frameOfMovieListView = self.movieListView.frame;
    
    self.moviesCreator = [[MoviesCreatorImpl alloc] init];
    
    self.movies = [[NSMutableArray alloc] init];
    
    [self setSubViewForMovieListView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.account = [[AccountManager getInstance] account];
}

- (void) viewDidAppear:(BOOL)animated {
    if(self.movies.count == 0) {
        [self excuteGetMovieFromAPI];
    }
}

- (UITableView *) tableView {
    if(!_tableView) {
        CGRect frameOfTableView = self.frameOfMovieListView;
        frameOfTableView.origin.y = 0;
        _tableView = [[UITableView alloc] initWithFrame:frameOfTableView style:UITableViewStylePlain];
        
        self.tableViewCreator = [[TableViewCreator alloc] initWithTableView: _tableView];
        self.tableViewCreator.delegate = self;
        
        // chua auto layout cho tableView
        _tableView.delegate = self.tableViewCreator;
        _tableView.dataSource = self.tableViewCreator;
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
        
        // chua auto layout cho collectionView
        _collectionView.delegate = self.collectionViewCreator;
        _collectionView.dataSource = self.collectionViewCreator;
        _collectionView.movies = self.movies;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UIAlertController *) alertViewController {
    if(!_alertViewController) {
        _alertViewController = [UIAlertController alertControllerWithTitle:@"" message:@"Waiting ..." preferredStyle:UIAlertControllerStyleAlert];
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        CGRect frameOfActivity = self.activityIndicator.frame;
        frameOfActivity.origin.x = 25;
        frameOfActivity.origin.y = 17.5;
        self.activityIndicator.frame = frameOfActivity;
        [_alertViewController.view addSubview: self.activityIndicator];
        [self.activityIndicator startAnimating];
    }
    return _alertViewController;
}

- (void) dismissAlertViewController: (BOOL)animated completion: (void(^)(void))completion {
    [self.activityIndicator stopAnimating];
    [self dismissViewControllerAnimated:animated completion:completion];
    self.alertViewControllerIsActive = NO;
}

- (void) setSubViewForMovieListView {
    NSArray<__kindof UIView *> * subViews = self.movieListView.subviews;
    if(!subViews || subViews.count == 0) {
        [self.movieListView addSubview: self.tableView];
        [self setImageButtonChangeMovieList: TABLE_VIEW];
    }
    else {
        UIView * firstView = [subViews firstObject];
        if([firstView isKindOfClass: [UITableView class]]) {
            [self.tableView removeFromSuperview];
            [self.movieListView addSubview: self.collectionView];
            [self setImageButtonChangeMovieList: COLLECTION_VIEW];
        }
        else {
            [self.collectionView removeFromSuperview];
            [self.movieListView addSubview: self.tableView];
            [self setImageButtonChangeMovieList: TABLE_VIEW];
        }
    }
}

- (void) excuteGetMovieFromAPI {
    if(!self.alertViewControllerIsActive) {
        [self presentViewController:self.alertViewController animated:YES completion:nil];
        self.alertViewControllerIsActive = YES;
    }
    __weak MovieListViewController * weakSelf = self;
    [self.moviesCreator createMoviesWithPageNumber:self.pageNumber success:^(NSMutableArray<Movie *> * _Nonnull movies) {
        [weakSelf.movies addObjectsFromArray: [NSArray arrayWithArray: movies]];
        id subview = [weakSelf.movieListView.subviews firstObject];
        [subview setMovies: weakSelf.movies];
        dispatch_async(dispatch_get_main_queue(), ^{
            [subview reloadData];
            [weakSelf.alertViewController dismissViewControllerAnimated:NO completion:nil];
        });
    } failure:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.alertViewController dismissViewControllerAnimated:NO completion: ^ {
                if(!weakSelf.alertErrorViewController) {
                    weakSelf.alertErrorViewController = [UIAlertController alertControllerWithTitle:@"💔💔💔" message:@"We can't load movie collection" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                        [weakSelf excuteGetMovieFromAPI];
                    }];
                    [weakSelf.alertErrorViewController addAction: tryAgain];
                    
                    UIAlertAction * actionExit = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        exit(0);
                    }];
                    [weakSelf.alertErrorViewController addAction: actionExit];
                }
                [weakSelf presentViewController:weakSelf.alertErrorViewController animated:YES completion:nil];
            }] ;
        });
    }];
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

#pragma mark <TableViewCreatorDelegate>

- (void) addOrRemoveFavouriteMovie:(Movie *)movie {
    if(!self.account) {
        [self showMessageErrorCantAddFavouriteMovie];
    }
    else {
        if(!self.account.favouriteMovies) {
            self.account.favouriteMovies = [[NSMutableSet alloc] init];
        }
        BOOL exist = NO;
        for(Movie * item in self.account.favouriteMovies) {
            if(item.identifier == movie.identifier) {
                exist = YES;
                break;
            }
        }
        if(exist) {
            if(movie.isFavouriteMovie) {
                
            }
        }
        else {
        
        }
        if(movie.isFavouriteMovie) {
            
        }
        else {
        
        }
    }
}

- (void) pushDetailViewController:(DetailViewController *)detailViewController {
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void) showMessageErrorCantAddFavouriteMovie {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"🙏🙏🙏" message:@"You must be logged in to perform this feature" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Login now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
