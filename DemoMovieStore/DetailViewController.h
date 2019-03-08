#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TabItemViewController.h"
#import "DetailViewControllerDelegate.h"
#import "EditProfileViewControllerDelegate.h"

@interface DetailViewController : TabItemViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EditProfileViewControllerDelegate>

@property (nonatomic) Movie * movie;

@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;

@end
