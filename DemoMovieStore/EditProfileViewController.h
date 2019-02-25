//
//  EditProfileViewController.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/22/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "EditProfileViewControllerDelegate.h"

@interface EditProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<EditProfileViewControllerDelegate> delegate;

@property (nonatomic, weak) Account * account;

@end
