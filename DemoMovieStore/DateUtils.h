#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSString *) stringFromDate: (NSDate *)date formatDate: (NSString *)formatOfDate;

+ (NSDate *) dateFromDateString: (NSString *)dateString formatDate: (NSString *)formatOfDate;

+ (NSInteger) yearFromDate: (NSDate *)date;

@end
