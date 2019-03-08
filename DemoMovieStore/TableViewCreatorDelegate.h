#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "Account.h"

@protocol TableViewCreatorDelegate <NSObject>

- (BOOL) isGranted;

- (void) addOrRemoveFavouriteMovie: (Movie *)movie;

- (void) pushDetailViewController: (DetailViewController *)detailViewController;

- (void) addOrSetReminderMovie:(Reminder *)reminder;

- (Reminder *) reminderWithMovieId: (NSInteger)movieId;

- (void) loadMore;

- (BOOL) checkFavouriteMovie: (Movie *)movie;

@end
