#import "AccountMO+CoreDataClass.h"
#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountMO (CoreDataProperties)

+ (NSFetchRequest<AccountMO *> *)fetchRequest;

+ (AccountMO *) fetchAccountMOWithIdentifier: (int32_t)identifier;

+ (Account *) fetchAccountWithIdentifier: (int32_t)identifier;

+ (BOOL) insertNewAccount: (Account *)account;

+ (BOOL) updateAccount: (Account *)account;

@property (nullable, nonatomic, retain) NSData *avartar;
@property (nullable, nonatomic, copy) NSDate *dateOfBirth;
@property (nullable, nonatomic, copy) NSString *email;
@property (nonatomic) int16_t gender;
@property (nonatomic) int32_t identifier;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<MovieMO *> *favouriteMovies;
@property (nullable, nonatomic, retain) NSSet<ReminderMO *> *reminderMovies;

@end

@interface AccountMO (CoreDataGeneratedAccessors)

- (void)addFavouriteMoviesObject:(MovieMO *)value;
- (void)removeFavouriteMoviesObject:(MovieMO *)value;
- (void)addFavouriteMovies:(NSSet<MovieMO *> *)values;
- (void)removeFavouriteMovies:(NSSet<MovieMO *> *)values;

- (void)addReminderMoviesObject:(ReminderMO *)value;
- (void)removeReminderMoviesObject:(ReminderMO *)value;
- (void)addReminderMovies:(NSSet<ReminderMO *> *)values;
- (void)removeReminderMovies:(NSSet<ReminderMO *> *)values;

@end

NS_ASSUME_NONNULL_END
