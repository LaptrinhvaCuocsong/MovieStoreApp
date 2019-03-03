//
//  Reminder.m
//  DemoMovieStore
//
//  Created by nguyen manh hung on 3/3/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "Reminder.h"
#import "Movie.h"

@implementation Reminder

- (instancetype) initWithReminderDate:(NSDate *)reminderDate movie:(Movie *)movie {
    self = [super init];
    if(self) {
        self.reminderDate = reminderDate;
        self.movie = movie;
    }
    return self;
}

@end
