//
//  DetailViewControllerDelegate.h
//  DemoMovieStore
//
//  Created by nguyen manh hung on 3/2/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DetailViewControllerDelegate <NSObject>

- (BOOL) isGranted;

@optional

- (void) addOrRemoveFavouriteMovie: (Movie *)movie;

- (void) addOrSetReminderMovie: (Reminder *)reminder;

- (Reminder *) reminderWithMovieId: (NSInteger)movieId;

@end

NS_ASSUME_NONNULL_END
