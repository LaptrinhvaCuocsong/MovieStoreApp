#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Movie;

@interface Reminder : NSObject

@property (nonatomic) NSInteger identifer;

@property (nonatomic) NSDate * reminderDate;

@property (nonatomic, nonnull) Movie * movie;

- (instancetype) initWithReminderDate: (NSDate *)reminderDate movie: (Movie *)movie;

@end

NS_ASSUME_NONNULL_END
