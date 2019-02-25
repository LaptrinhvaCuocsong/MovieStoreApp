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

@interface FavoriteViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@pro

@property (nonatomic) NSMutableSet<Movie *> * movies;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak Account * account = [[AccountManager getInstance] account];
    if(account) {
        /*
        self.movies = [account.favouriteMovies copy];
        if(!self.movies) {
            self.movies = [[NSMutableSet alloc] init];
        }
         */
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

#pragma mark <UITableViewDataSource>

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
