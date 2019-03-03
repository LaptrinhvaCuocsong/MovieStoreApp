//
//  ReminderMO+CoreDataProperties.m
//  
//
//  Created by nguyen manh hung on 3/3/19.
//
//

#import "ReminderMO+CoreDataProperties.h"
#import "AppDelegate.h"
#import "MovieMO+CoreDataClass.h"

@implementation ReminderMO (CoreDataProperties)

static NSString * const ENTITY_NAME = @"Reminder";

static NSString * const CURRENT_IDENTIFIER = @"CurrentIdentifierOfReminderMO";

+ (NSFetchRequest<ReminderMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Reminder"];
}

+ (ReminderMO *) fetchReminderMOWithIdentifer: (int32_t)identifier {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName: ENTITY_NAME];
    [request setPredicate: [NSPredicate predicateWithFormat:@"SELF.identifier = %d", identifier]];
    NSError * error = nil;
    NSArray<ReminderMO *> * reminders = [context executeFetchRequest:request error:&error];
    if(error) {
        return nil;
    }
    ReminderMO * reminderMO = [reminders firstObject];
    if(reminderMO) {
        return reminderMO;
    }
    return nil;
}

+ (ReminderMO *) insertNewRemender:(Reminder *)reminder {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    ReminderMO * reminderMO = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
    if(reminderMO) {
        NSInteger currentIdentifier = [[NSUserDefaults standardUserDefaults] integerForKey: CURRENT_IDENTIFIER];
        reminderMO.identifier = (int32_t)++currentIdentifier;
        reminderMO.reminderDate = reminder.reminderDate;
        reminderMO.movie = [ReminderMO movieMOfromMovie: reminder.movie];
        if(context.hasChanges) {
            NSError * error = nil;
            BOOL isInserted = [context save: &error];
            if(isInserted && !error) {
                NSLog(@"Insert reminder success");
                [[NSUserDefaults standardUserDefaults] setInteger:currentIdentifier forKey:CURRENT_IDENTIFIER];
            }
            else {
                return nil;
            }
        }
    }
    else {
        return nil;
    }
    return reminderMO;
}

+ (MovieMO *) movieMOfromMovie: (Movie *)movie {
    if(movie) {
        MovieMO * movieMO = [MovieMO fetchMovieMOWithIdentifier:(int32_t) movie.identifier];
        if(movieMO) {
            return movieMO;
        }
        else {
            return [MovieMO insertNewMovie: movie];
        }
    }
    return nil;
}

@dynamic identifier;
@dynamic reminderDate;
@dynamic account;
@dynamic movie;

@end
