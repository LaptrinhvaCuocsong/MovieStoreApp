#import <UIKit/UIKit.h>
#import "objc/message.h"
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Extent)

@property (nonatomic) NSArray<Movie *> * movies;

@end

NS_ASSUME_NONNULL_END
