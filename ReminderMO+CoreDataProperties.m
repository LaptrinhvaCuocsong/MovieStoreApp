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

+ (BOOL) insertNewRemender:(Reminder *)reminder {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    ReminderMO * reminderMO = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
    if(reminderMO) {
        NSInteger currentIdentifier = [[NSUserDefaults standardUserDefaults] integerForKey: CURRENT_IDENTIFIER];
        reminder.identifer = ++ currentIdentifier;
        reminderMO.identifier = (int32_t) reminder.identifer;
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
                return NO;
            }
        }
    }
    else {
        return NO;
    }
    return YES;
}

+ (BOOL) updateReminder: (Reminder *)reminder {
    NSManagedObjectContext * context = [AppDelegate managedObjectContext];
    ReminderMO * reminderMO = [ReminderMO fetchReminderMOWithIdentifer: (int32_t)reminder.identifer];
    if(reminderMO) {
        reminderMO.reminderDate = reminder.reminderDate;
        if(context.hasChanges) {
            NSError * error = nil;
            BOOL isSaved = [context save: &error];
            if(isSaved && !error) {
                NSLog(@"Update Reminder success");
            }
            else {
                return NO;
            }
        }
    }
    return YES;
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
