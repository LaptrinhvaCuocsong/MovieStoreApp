#import <UIKit/UIKit.h>
#import "Cast.h"

@interface CastCollectionViewCell : UICollectionViewCell

- (void) setCastCollectionViewCell: (Cast * _Nonnull)cast imageURLString: (NSString * _Nullable)imageURLString arrayImageURLString: (NSMutableArray * _Nonnull)arrayImageURLString;

@end
