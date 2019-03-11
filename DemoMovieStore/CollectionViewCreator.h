#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CollectionViewCreatorDelegate.h"
#import "DetailViewControllerDelegate.h"

@interface CollectionViewCreator : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, DetailViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<CollectionViewCreatorDelegate> delegate;

- (instancetype) initWithCollectionView: (UICollectionView *)collectionView;

@end
