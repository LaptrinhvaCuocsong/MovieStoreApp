#import <Foundation/Foundation.h>
#import "Movie.h"
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GENDER) {
    MALE = 0
    , FEMALE
};

@interface Account : NSObject

@property (nonatomic) NSInteger indentifier;

@property (nonatomic) NSString * name;

@property (nonatomic) NSDate * dateOfBirth;

@property (nonatomic) NSString * email;

@property (nonatomic) GENDER gender;

@property (nonatomic) NSData * avartar;

@property (nonatomic) NSMutableSet<Movie *> * favouriteMovies;

@property (nonatomic) NSMutableSet<Reminder *> * reminderMovies;

- (instancetype) initWithName: (NSString *)name dateOfBirth: (NSDate *)dateOfBirth email: (NSString *)email gender: (GENDER)gender avartar: (NSData *)avartar;

@end

NS_ASSUME_NONNULL_END
