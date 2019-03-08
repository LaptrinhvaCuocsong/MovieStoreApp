#import <Foundation/Foundation.h>
#import "Constants.h"

@interface NSMutableDictionary (SettingOfAccount)

- (NSString *) urlString;

- (void) setUrlString: (NSString *)urlString;

- (float) movieRate;

- (void) setMovieRate: (float)movieRate;

- (NSInteger) releaseYear;

- (void) setReleaseYear: (NSInteger)releaseYear;

- (TYPE_OF_SORT) typeOfSort;

- (void) setTypeOfSort: (TYPE_OF_SORT)typeOfSort;

@end
