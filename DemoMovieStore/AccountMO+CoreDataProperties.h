//
//  AccountMO+CoreDataProperties.h
//  
//
//  Created by RTC-HN149 on 2/22/19.
//
//

#import "AccountMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AccountMO (CoreDataProperties)

+ (NSFetchRequest<AccountMO *> *)fetchRequest;

@property (nonatomic) int32_t identifier;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *dateOfBirth;
@property (nullable, nonatomic, copy) NSString *email;
@property (nonatomic) int16_t sex;
@property (nullable, nonatomic, copy) NSString *imageURL;
@property (nullable, nonatomic, retain) NSSet<FavouriteMovieMO *> *favouriteMovies;

@end

@interface AccountMO (CoreDataGeneratedAccessors)

- (void)addFavouriteMoviesObject:(FavouriteMovieMO *)value;
- (void)removeFavouriteMoviesObject:(FavouriteMovieMO *)value;
- (void)addFavouriteMovies:(NSSet<FavouriteMovieMO *> *)values;
- (void)removeFavouriteMovies:(NSSet<FavouriteMovieMO *> *)values;

@end

NS_ASSUME_NONNULL_END
