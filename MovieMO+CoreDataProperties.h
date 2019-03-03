//
//  MovieMO+CoreDataProperties.h
//  
//
//  Created by nguyen manh hung on 3/3/19.
//
//

#import "MovieMO+CoreDataClass.h"
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieMO (CoreDataProperties)

+ (NSFetchRequest<MovieMO *> *)fetchRequest;

+ (MovieMO *) fetchMovieMOWithIdentifier: (int32_t)identifier;

+ (MovieMO *) insertNewMovie: (Movie *)movie;

@property (nonatomic) BOOL adult;
@property (nonatomic) int32_t identifier;
@property (nullable, nonatomic, copy) NSString *overview;
@property (nullable, nonatomic, copy) NSString *posterPath;
@property (nullable, nonatomic, copy) NSDate *releaseDate;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) float voteAverage;
@property (nullable, nonatomic, retain) AccountMO *account;
@property (nullable, nonatomic, retain) ReminderMO *reminderMovie;

@end

NS_ASSUME_NONNULL_END
