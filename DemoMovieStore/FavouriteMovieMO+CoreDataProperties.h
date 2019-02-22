//
//  FavouriteMovieMO+CoreDataProperties.h
//  
//
//  Created by RTC-HN149 on 2/22/19.
//
//

#import "FavouriteMovieMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavouriteMovieMO (CoreDataProperties)

+ (NSFetchRequest<FavouriteMovieMO *> *)fetchRequest;

@property (nonatomic) int32_t identifier;
@property (nonatomic) float voteAverage;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *posterPath;
@property (nonatomic) BOOL adult;
@property (nullable, nonatomic, copy) NSString *overview;
@property (nullable, nonatomic, copy) NSDate *releaseDate;
@property (nonatomic) int32_t accountIdentifier;
@property (nullable, nonatomic, retain) NSSet<AccountMO *> *account;

@end

@interface FavouriteMovieMO (CoreDataGeneratedAccessors)

- (void)addAccountObject:(AccountMO *)value;
- (void)removeAccountObject:(AccountMO *)value;
- (void)addAccount:(NSSet<AccountMO *> *)values;
- (void)removeAccount:(NSSet<AccountMO *> *)values;

@end

NS_ASSUME_NONNULL_END
