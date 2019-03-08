#import "NSDictionary+Reminder.h"

@implementation NSDictionary (Reminder)

- (NSInteger) reminderId {
    NSNumber * n = self[@"reminderId"];
    return [n integerValue];
}

@end
