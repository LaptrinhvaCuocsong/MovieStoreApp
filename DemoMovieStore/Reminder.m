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
