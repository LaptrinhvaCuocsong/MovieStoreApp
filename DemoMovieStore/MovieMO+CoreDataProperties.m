//
//  MovieMO+CoreDataProperties.m
//  
//
//  Created by nguyen manh hung on 2/23/19.
//
//

#import "MovieMO+CoreDataProperties.h"
#import "AppDelegate.h"

@implementation MovieMO (CoreDataProperties)

static NSString * const CURRENT_IDENTIFIER = @"CurrentIdentifierOfMovieKey";

static NSString * const ENTITY_NAME = @"Movie";

+ (NSFetchRequest<MovieMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
}

+ (MovieMO *) fetchMovieMOWithIdentifier: (int32_t)identifier {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: ENTITY_NAME];
    NSError * error = nil;
    NSArray<MovieMO *> * movies = [context executeFetchRequest:request error:&error];
    if(error) {
        return nil;
    }
    NSArray<MovieMO *> * movieFilters = [movies filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject) {
            MovieMO * movieMO = (MovieMO *)evaluatedObject;
            if(identifier != movieMO.identifier) {
                return NO;
            }
        }
        else {
            return NO;
        }
        return YES;
    }]];
    if(movieFilters) {
        return [movieFilters firstObject];
    }
    else {
        return nil;
    }
}

+ (MovieMO *) insertNewMovie: (Movie *)movie {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    MovieMO * movieMO = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
    if(movieMO) {
        NSInteger currentIdentifer = [[NSUserDefaults standardUserDefaults] integerForKey: CURRENT_IDENTIFIER];
        currentIdentifer = (currentIdentifer)?currentIdentifer:0;
        movieMO.identifier = (int32_t)++currentIdentifer;
        movieMO.voteAverage = movie.voteAverage;
        movieMO.title = movie.title;
        movieMO.posterPath = movie.posterPath;
        movieMO.adult = movie.adult;
        movieMO.overview = movie.overview;
        movie.releaseDate = movie.releaseDate;
        if(context.hasChanges) {
            NSError * error = nil;
            if([context save:&error]) {
                NSLog(@"Insert success");
                [[NSUserDefaults standardUserDefaults] setInteger:currentIdentifer forKey:CURRENT_IDENTIFIER];
            }
            else {
                return nil;
            }
        }
    }
    return movieMO;
}

@dynamic identifier;
@dynamic voteAverage;
@dynamic title;
@dynamic posterPath;
@dynamic adult;
@dynamic overview;
@dynamic releaseDate;
@dynamic account;

@end
