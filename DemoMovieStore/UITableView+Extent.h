#import <UIKit/UIKit.h>
#import "objc/message.h"
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Extent)

@property (nonatomic) NSArray<Movie *> * _Nonnull movies;

@end

NS_ASSUME_NONNULL_END
