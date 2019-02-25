//
//  MovieMO+CoreDataProperties.h
//  
//
//  Created by nguyen manh hung on 2/23/19.
//
//

#import "MovieMO+CoreDataClass.h"
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieMO (CoreDataProperties)

+ (NSFetchRequest<MovieMO *> *)fetchRequest;

+ (MovieMO *) insertNewMovie: (Movie *)movie;

+ (MovieMO *) fetchMovieMOWithIdentifier: (int32_t)identifier;

@property (nonatomic) int32_t identifier;
@property (nonatomic) float voteAverage;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *posterPath;
@property (nonatomic) BOOL adult;
@property (nullable, nonatomic, copy) NSString *overview;
@property (nullable, nonatomic, copy) NSDate *releaseDate;
@property (nullable, nonatomic, retain) AccountMO *account;

@end

NS_ASSUME_NONNULL_END
