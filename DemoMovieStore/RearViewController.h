#import <UIKit/UIKit.h>
#import "EditProfileViewControllerDelegate.h"

@interface RearViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EditProfileViewControllerDelegate>

@property (nonatomic) UIViewController * frontViewController;

@end
