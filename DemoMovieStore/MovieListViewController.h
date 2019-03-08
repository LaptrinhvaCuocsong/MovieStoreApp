#import <UIKit/UIKit.h>
#import "TabItemViewController.h"
#import "TableViewCreatorDelegate.h"
#import "CollectionViewCreatorDelegate.h"
#import "EditProfileViewControllerDelegate.h"

@interface MovieListViewController : TabItemViewController <TableViewCreatorDelegate, CollectionViewCreatorDelegate, EditProfileViewControllerDelegate>

@end
