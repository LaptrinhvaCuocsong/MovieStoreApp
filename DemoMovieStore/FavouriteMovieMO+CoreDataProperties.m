//
//  FavouriteMovieMO+CoreDataProperties.m
//  
//
//  Created by RTC-HN149 on 2/22/19.
//
//

#import "FavouriteMovieMO+CoreDataProperties.h"

@implementation FavouriteMovieMO (CoreDataProperties)

+ (NSFetchRequest<FavouriteMovieMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FavouriteMovie"];
}

@dynamic identifier;
@dynamic voteAverage;
@dynamic title;
@dynamic posterPath;
@dynamic adult;
@dynamic overview;
@dynamic releaseDate;
@dynamic accountIdentifier;
@dynamic account;

@end
