//
//  ReminderMO+CoreDataProperties.h
//  
//
//  Created by nguyen manh hung on 3/3/19.
//
//

#import "ReminderMO+CoreDataClass.h"
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReminderMO (CoreDataProperties)

+ (NSFetchRequest<ReminderMO *> *)fetchRequest;

+ (ReminderMO *) fetchReminderMOWithIdentifer: (int32_t)identifier;

+ (ReminderMO *) insertNewRemender: (Reminder *)reminder;

@property (nonatomic) int32_t identifier;
@property (nullable, nonatomic, copy) NSDate *reminderDate;
@property (nullable, nonatomic, retain) AccountMO *account;
@property (nullable, nonatomic, retain) MovieMO *movie;

@end

NS_ASSUME_NONNULL_END
