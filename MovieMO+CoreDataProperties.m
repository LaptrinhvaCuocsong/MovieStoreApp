#import "MovieMO+CoreDataProperties.h"
#import "AppDelegate.h"

@implementation MovieMO (CoreDataProperties)

static NSString * const ENTITY_NAME = @"Movie";

+ (NSFetchRequest<MovieMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
}

+ (MovieMO *) fetchMovieMOWithIdentifier: (int32_t)identifier {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: ENTITY_NAME];
    [request setPredicate: [NSPredicate predicateWithFormat: @"SELF.identifier = %d", identifier]];
    NSError * error = nil;
    NSArray<MovieMO *> * array = [context executeFetchRequest:request error:&error];
    MovieMO * movieMO = [array firstObject];
    if(movieMO) {
        return movieMO;
    }
    return nil;
}

+ (MovieMO *) insertNewMovie: (Movie *)movie {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    MovieMO * movieMO = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
    if(movieMO) {
        movieMO.identifier = (int32_t)movie.identifier;
        movieMO.voteAverage = movie.voteAverage;
        movieMO.title = movie.title;
        movieMO.posterPath = movie.posterPath;
        movieMO.adult = movie.adult;
        movieMO.overview = movie.overview;
        movie.releaseDate = movie.releaseDate;
        if(context.hasChanges) {
            NSError * error = nil;
            if([context save:&error]) {
            }
            else {
                return nil;
            }
        }
    }
    return movieMO;
}

@dynamic adult;
@dynamic identifier;
@dynamic overview;
@dynamic posterPath;
@dynamic releaseDate;
@dynamic title;
@dynamic voteAverage;
@dynamic account;
@dynamic reminderMovie;

@end
