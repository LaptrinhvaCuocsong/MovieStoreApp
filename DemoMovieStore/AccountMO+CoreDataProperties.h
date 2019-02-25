//
//  AccountMO+CoreDataProperties.h
//  
//
//  Created by RTC-HN149 on 2/22/19.
//
//

#import "AccountMO+CoreDataClass.h"
#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountMO (CoreDataProperties)

+ (NSFetchRequest<AccountMO *> *)fetchRequest;

+ (Account *) fetchAccountWithIdentifier: (int32_t)identifier;

+ (BOOL) insertNewAccount: (Account *)account;

+ (BOOL) updateAccount: (Account *)account;

@property (nonatomic) int32_t identifier;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *dateOfBirth;
@property (nullable, nonatomic, copy) NSString *email;
@property (nonatomic) int16_t gender;
@property (nullable, nonatomic, copy) NSData *avartar;
@property (nullable, nonatomic, retain) NSSet<MovieMO *> *favouriteMovies;

@end

@interface AccountMO (CoreDataGeneratedAccessors)

- (void)addFavouriteMoviesObject:(MovieMO *)value;
- (void)removeFavouriteMoviesObject:(MovieMO *)value;
- (void)addFavouriteMovies:(NSSet<MovieMO *> *)values;
- (void)removeFavouriteMovies:(NSSet<MovieMO *> *)values;

@end

NS_ASSUME_NONNULL_END
