//
//  AccountMO+CoreDataProperties.m
//  
//
//  Created by RTC-HN149 on 2/22/19.
//
//

#import "AccountMO+CoreDataProperties.h"

@implementation AccountMO (CoreDataProperties)

+ (NSFetchRequest<AccountMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Account"];
}

@dynamic identifier;
@dynamic name;
@dynamic dateOfBirth;
@dynamic email;
@dynamic sex;
@dynamic imageURL;
@dynamic favouriteMovies;

@end
