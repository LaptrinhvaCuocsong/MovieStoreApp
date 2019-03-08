#import <Foundation/Foundation.h>
#import "DetailViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CollectionViewCreatorDelegate <NSObject>

- (BOOL) isGranted;

- (void) addOrRemoveFavouriteMovie: (Movie *)movie;

- (void) pushDetailViewController: (DetailViewController *)detailViewController;

- (void) addOrSetReminderMovie:(Reminder *)reminder;

- (Reminder *) reminderWithMovieId: (NSInteger)movieId;

- (void) loadMore;

- (BOOL) checkFavouriteMovie: (Movie *)movie;

@end

NS_ASSUME_NONNULL_END
