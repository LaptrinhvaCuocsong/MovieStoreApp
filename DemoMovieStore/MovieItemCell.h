#import <UIKit/UIKit.h>
#import "Movie.h"
#import "MovieItemCellDelegate.h"

@interface MovieItemCell : UITableViewCell

@property (nonatomic, weak) _Nullable id<MovieItemCellDelegate> delegate;

- (void) setMovieItemCell: (Movie * _Nonnull)movie;

@end
