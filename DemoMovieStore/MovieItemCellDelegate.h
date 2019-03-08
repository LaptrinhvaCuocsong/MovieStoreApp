#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol MovieItemCellDelegate <NSObject>

- (BOOL) isGranted;

- (void) addOrRemoveFavouriteMovie: (Movie *)movie;

@end
