#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewControllerDelegate <NSObject>

- (BOOL) isGranted;

@optional

- (void) addOrRemoveFavouriteMovie: (Movie *)movie;

- (void) addOrSetReminderMovie: (Reminder *)reminder;

- (Reminder *) reminderWithMovieId: (NSInteger)movieId;

- (BOOL) checkFavouriteMovie: (Movie *)movie;

- (void) removeReminderMovie: (Reminder *)reminder;

@end

NS_ASSUME_NONNULL_END
