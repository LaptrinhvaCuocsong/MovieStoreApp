//
//  CollectionViewCreatorDelegate.h
//  DemoMovieStore
//
//  Created by nguyen manh hung on 2/22/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

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
