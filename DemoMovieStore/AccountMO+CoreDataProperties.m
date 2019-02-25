//
//  AccountMO+CoreDataProperties.m
//  
//
//  Created by RTC-HN149 on 2/22/19.
//
//

#import "AccountMO+CoreDataProperties.h"
#import "AppDelegate.h"
#import "Movie.h"
#import "MovieMO+CoreDataClass.h"

@implementation AccountMO (CoreDataProperties)

static NSString * const CURRENT_IDENTIFIER = @"CurrentIdentifierOfAccountKey";

static NSString * const ENTITY_NAME = @"Account";

+ (NSFetchRequest<AccountMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Account"];
}

+ (AccountMO *) fetchAccountMOWithIdentifier: (int32_t)identifier {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: ENTITY_NAME];
    NSError * error = nil;
    NSArray<AccountMO *> * accounts = [context executeFetchRequest:request error:&error];
    if(error) {
        return nil;
    }
    NSArray<AccountMO *> * accountFilters = [accounts filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject) {
            AccountMO * accountMO = (AccountMO *)evaluatedObject;
            if(identifier != accountMO.identifier) {
                return NO;
            }
        }
        else {
            return NO;
        }
        return YES;
    }]];
    if(accountFilters) {
        return [accountFilters firstObject];
    }
    else {
        return nil;
    }
}

+ (Account *) fetchAccountWithIdentifier: (int32_t)identifier {
    Account * account = [[Account alloc] init];
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: ENTITY_NAME];
    NSError * error = nil;
    NSArray<AccountMO *> * accounts = [context executeFetchRequest:request error:&error];
    if(error) {
        return nil;
    }
    NSArray<AccountMO *> * accountFilters = [accounts filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject) {
            AccountMO * accountMO = (AccountMO *)evaluatedObject;
            if(identifier != accountMO.identifier) {
                return NO;
            }
        }
        else {
            return NO;
        }
        return YES;
    }]];
    if(accountFilters) {
        AccountMO * accountMO = [accountFilters firstObject];
        if(accountMO) {
            account.indentifier = accountMO.identifier;
            account.name = accountMO.name;
            account.dateOfBirth = accountMO.dateOfBirth;
            account.email = accountMO.email;
            account.gender = accountMO.gender;
            account.avartar = accountMO.avartar;
            NSMutableSet * set = [[NSMutableSet alloc] init];
            for(MovieMO * item in accountMO.favouriteMovies) {
                Movie * movie = [[Movie alloc] initWithIdentifier:item.identifier voteAverage:item.voteAverage title:item.title posterPath:item.posterPath adult:item.adult overview:item.overview releaseDate:item.releaseDate];
                [set addObject: movie];
            }
            account.favouriteMovies = set;
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
    return account;
}

+ (BOOL) insertNewAccount: (Account *)account {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    AccountMO * accountMO = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
    if(accountMO) {
        NSInteger currentIdentifer = [[NSUserDefaults standardUserDefaults] integerForKey: CURRENT_IDENTIFIER];
        currentIdentifer = (currentIdentifer)?currentIdentifer:0;
        account.indentifier = ++currentIdentifer;
        accountMO.identifier = (int32_t)currentIdentifer;
        accountMO.name = account.name;
        accountMO.dateOfBirth= account.dateOfBirth;
        accountMO.email = account.email;
        accountMO.gender = account.gender;
        if(context.hasChanges) {
            NSError * error = nil;
            BOOL isSaved = [context save: &error];
            if(isSaved && !error) {
                NSLog(@"Insert success");
                [[NSUserDefaults standardUserDefaults] setInteger:currentIdentifer forKey:CURRENT_IDENTIFIER];
            }
            else {
                return NO;
            }
        }
    }
    else {
        return NO;
    }
    return YES;
}

+ (BOOL) updateAccount: (Account *)account {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: ENTITY_NAME];
    NSError * error = nil;
    NSArray<AccountMO *> * accounts = [context executeFetchRequest:request error: &error];
    if(error) {
        return NO;
    }
    NSArray<AccountMO *> * accountFilters = [accounts filteredArrayUsingPredicate: [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject) {
            AccountMO * accountMO = (AccountMO *)evaluatedObject;
            int32_t identifier = accountMO.identifier;
            if(identifier != account.indentifier) {
                return NO;
            }
        }
        else {
            return NO;
        }
        return YES;
    }]];
    if(accountFilters) {
        AccountMO * accountMO = [accountFilters firstObject];
        if(accountMO) {
            accountMO.dateOfBirth = account.dateOfBirth;
            accountMO.email = account.email;
            accountMO.gender = account.gender;
            accountMO.avartar = account.avartar;
            NSMutableSet * sets = account.favouriteMovies;
            if(sets) {
                for(Movie * movie in sets) {
                    MovieMO * movieMO = [MovieMO fetchMovieMOWithIdentifier:(int32_t)movie.identifier];
                    if(movieMO) {
                        [accountMO addFavouriteMoviesObject: movieMO];
                    }
                    else {
                        MovieMO * movieMO = [MovieMO insertNewMovie: movie];
                        if(movieMO) {
                            [accountMO addFavouriteMoviesObject: movieMO];
                        }
                        else {
                            return NO;
                        }
                    }
                }
            }
            if(context.hasChanges) {
                NSError * error = nil;
                [context save: &error];
                if(error) {
                    return NO;
                }
            }
        }
        else {
            return NO;
        }
    }
    return YES;
}

@dynamic identifier;
@dynamic name;
@dynamic dateOfBirth;
@dynamic email;
@dynamic gender;
@dynamic avartar;
@dynamic favouriteMovies;

@end
