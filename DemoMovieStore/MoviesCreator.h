#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol MoviesCreator <NSObject>
 
- (void) createMoviesWithPageNumber: (NSUInteger) pageNumber success: (void(^ _Nonnull)(NSMutableArray<Movie *> * _Nonnull movies, NSInteger totalPages))success failure: (void(^ _Nonnull)(void))failure urlString: (NSString * _Nonnull)urlString;

@end
