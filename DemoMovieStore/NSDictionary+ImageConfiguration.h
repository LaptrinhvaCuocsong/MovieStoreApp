#import <Foundation/Foundation.h>

@interface NSDictionary (ImageConfiguration)

- (NSString *) secureBaseURL;

- (NSArray *) backdropSizes;

- (NSArray *) logoSizes;

- (NSArray *) posterSizes;

- (NSArray *) profileSizes;

- (NSArray *) stillSizes;

@end
