//
//  ReminderViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 3/4/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderTableViewCell.h"
#import "Account.h"
#import "AccountManager.h"
#import "Reminder.h"
#import "Constants.h"
#import "Constants.h"
#import "DetailViewController.h"
#import "Movie.h"

@interface ReminderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) Account * account;

@property (nonatomic) NSMutableArray<Reminder *> * reminderMovies;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:REMINDER_TABLE_VIEW_CELL bundle:nil] forCellReuseIdentifier:REMINDER_TABLE_VIEW_CELL];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.account = [[AccountManager getInstance] account];
    if(self.account) {
        if(self.account.reminderMovies) {
            NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reminderDate" ascending:YES];
            NSArray * array = @[sortDescriptor];
            NSArray<Reminder *> * arraySorted = [self.account.reminderMovies sortedArrayUsingDescriptors: array];
            if(arraySorted) {
                self.reminderMovies = [NSMutableArray arrayWithArray: arraySorted];
            }
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL) movieIsFavourite: (Movie *)movie {
    if(self.account) {
        if(self.account.favouriteMovies) {
            Movie * m = [[self.account.favouriteMovies filteredSetUsingPredicate: [NSPredicate predicateWithFormat:@"SELF.identifier = %ld", movie.identifier]] anyObject];
            if(m) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark <UITableViewDataSource>

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.reminderMovies) {
        return self.reminderMovies.count;
    }
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReminderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:REMINDER_TABLE_VIEW_CELL forIndexPath:indexPath];
    [cell setReminderTableViewCell: [self.reminderMovies objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController * detailViewController = [mainStoryBoard instantiateViewControllerWithIdentifier: DETAIL_VIEW_CONTROLLER_MAIN_STORYBOARD];
    Movie * movie = [[self.reminderMovies objectAtIndex: indexPath.row] movie];
    if([self movieIsFavourite: movie]) {
        movie.isFavouriteMovie = YES;
    }
    detailViewController.movie = movie;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark <DetailViewControllerDelegate>

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

- (void) showMessageError {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"🙏🙏🙏" message:@"You must be logged in to perform this feature" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Login now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
