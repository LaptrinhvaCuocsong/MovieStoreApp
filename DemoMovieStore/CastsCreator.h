#import <Foundation/Foundation.h>
#import "Cast.h"

@protocol CastsCreator <NSObject>

- (void) createCastWithMovieId: (NSUInteger)movieId success: (void(^ _Nonnull)(NSMutableArray<Cast *> * _Nonnull casts))success failure: (void(^ _Nonnull)(void))failure;

@end
