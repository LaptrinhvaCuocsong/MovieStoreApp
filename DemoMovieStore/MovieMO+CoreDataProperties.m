//
//  MovieMO+CoreDataProperties.m
//  
//
//  Created by nguyen manh hung on 2/23/19.
//
//

#import "MovieMO+CoreDataProperties.h"

@implementation MovieMO (CoreDataProperties)

+ (NSFetchRequest<MovieMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
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
