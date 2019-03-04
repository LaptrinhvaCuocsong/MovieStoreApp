#import "AccountMO+CoreDataProperties.h"
#import "AppDelegate.h"
#import "MovieMO+CoreDataClass.h"
#import "ReminderMO+CoreDataClass.h"

@implementation AccountMO (CoreDataProperties)

static NSString * const CURRENT_IDENTIFIER = @"CurrentIdentifierOfAccountKey";

static NSString * const ENTITY_NAME = @"Account";

+ (NSFetchRequest<AccountMO *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"Account"];
}

+ (AccountMO *) fetchAccountMOWithIdentifier: (int32_t)identifier {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: ENTITY_NAME];
    [request setPredicate:[NSPredicate predicateWithFormat:@"SELF.identifier = %d", identifier]];
    NSError * error = nil;
    NSArray<AccountMO *> *accountFilters = [context executeFetchRequest:request error:&error];
    if(error) {
        return nil;
    }
    AccountMO * accountMO = [accountFilters firstObject];
    if(accountMO) {
        return accountMO;
    }
    return nil;
}

+ (Account *) fetchAccountWithIdentifier: (int32_t)identifier {
    Account * account = [[Account alloc] init];
    AccountMO * accountMO = [AccountMO fetchAccountMOWithIdentifier: identifier];
    if(accountMO) {
        account.indentifier = accountMO.identifier;
        account.name = accountMO.name;
        account.dateOfBirth = accountMO.dateOfBirth;
        account.email = accountMO.email;
        account.gender = accountMO.gender;
        account.avartar = accountMO.avartar;
        NSMutableSet * favouriteMovies = [[NSMutableSet alloc] init];
        for(MovieMO * item in accountMO.favouriteMovies) {
            Movie * movie = [[Movie alloc] initWithIdentifier:item.identifier voteAverage:item.voteAverage title:item.title posterPath:item.posterPath adult:item.adult overview:item.overview releaseDate:item.releaseDate];
            movie.isFavouriteMovie = YES;
            [favouriteMovies addObject: movie];
        }
        account.favouriteMovies = favouriteMovies;
        NSMutableSet * reminderMovies = [[NSMutableSet alloc] init];
        for(ReminderMO * item in accountMO.reminderMovies) {
            Movie * movie = [[Movie alloc] initWithIdentifier:item.movie.identifier voteAverage:item.movie.voteAverage title:item.movie.title posterPath:item.movie.posterPath adult:item.movie.adult overview:item.movie.overview releaseDate:item.movie.releaseDate];
            Reminder * reminder = [[Reminder alloc] initWithReminderDate:item.reminderDate movie:movie];
            reminder.identifer = item.identifier;
            movie.reminder = reminder;
            [reminderMovies addObject: reminder];
        }
        account.reminderMovies = reminderMovies;
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
                NSLog(@"Insert Account success");
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
    AccountMO * accountMO = [AccountMO fetchAccountMOWithIdentifier:(int32_t) account.indentifier];
    if(accountMO) {
        accountMO.name = account.name;
        accountMO.dateOfBirth = account.dateOfBirth;
        accountMO.email = account.email;
        accountMO.gender = account.gender;
        accountMO.avartar = account.avartar;
        [AccountMO setFavouriteMovies:accountMO account:account];
        [AccountMO setReminderMovies:accountMO account:account];
        if(context.hasChanges) {
            NSError * error = nil;
            [context save: &error];
            if(error) {
                return NO;
            }
        }
    }
    NSLog(@"Update Account success");
    return YES;
}

+ (void) setFavouriteMovies: (AccountMO *)accountMO account: (Account *)account {
    [accountMO.favouriteMovies enumerateObjectsUsingBlock:^(MovieMO * _Nonnull movieMO, BOOL * _Nonnull stop) {
        __block BOOL isExist = NO;
        [account.favouriteMovies enumerateObjectsUsingBlock:^(Movie * _Nonnull movie, BOOL * _Nonnull stop) {
            if(movieMO.identifier == movie.identifier) {
                isExist = YES;
                [account.favouriteMovies removeObject:movie];
            }
        }];
        if(!isExist) {
            [accountMO removeFavouriteMoviesObject: movieMO];
        }
    }];
    for(Movie * movie in account.favouriteMovies) {
        MovieMO * movieMO = [MovieMO fetchMovieMOWithIdentifier: (int32_t)movie.identifier];
        if(movieMO) {
            BOOL exist = NO;
            for(MovieMO * item in accountMO.favouriteMovies) {
                if(movieMO.identifier == item.identifier) {
                    exist = YES;
                    break;
                }
            }
            if(!exist) {
                [accountMO addFavouriteMoviesObject: movieMO];
            }
        }
        else {
            MovieMO * movieMO = [MovieMO insertNewMovie: movie];
            if(movieMO) {
                [accountMO addFavouriteMoviesObject: movieMO];
            }
        }
    }
}

+ (void) setReminderMovies: (AccountMO *)accountMO account: (Account *)account {
    dispatch_group_t myGroup = dispatch_group_create();
    [accountMO.reminderMovies enumerateObjectsUsingBlock:^(ReminderMO * _Nonnull reminderMO, BOOL * _Nonnull stop) {
        __block BOOL isExist = NO;
        dispatch_group_enter(myGroup);
        [account.reminderMovies enumerateObjectsUsingBlock:^(Reminder * _Nonnull reminder, BOOL * _Nonnull stop) {
            if(reminderMO.identifier == reminder.identifer) {
                isExist = YES;
                reminderMO.reminderDate = reminder.reminderDate;
                [account.reminderMovies removeObject:reminder];
                dispatch_group_leave(myGroup);
            }
        }];
        dispatch_group_notify(myGroup, dispatch_get_main_queue(), ^{
            if(!isExist) {
                [accountMO removeReminderMoviesObject: reminderMO];
            }
        });
    }];
    for(Reminder * reminder in account.reminderMovies) {
        ReminderMO * reminderMO = [ReminderMO fetchReminderMOWithIdentifer: (int32_t)reminder.identifer];
        if(reminderMO) {
            [accountMO addReminderMoviesObject: reminderMO];
        }
    }
}

@dynamic avartar;
@dynamic dateOfBirth;
@dynamic email;
@dynamic gender;
@dynamic identifier;
@dynamic name;
@dynamic favouriteMovies;
@dynamic reminderMovies;

@end
