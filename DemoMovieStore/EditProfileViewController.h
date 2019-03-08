#import <UIKit/UIKit.h>
#import "Account.h"
#import "EditProfileViewControllerDelegate.h"

@interface EditProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic) Account * account;

@property (nonatomic, weak) id<EditProfileViewControllerDelegate> delegate;

@end
