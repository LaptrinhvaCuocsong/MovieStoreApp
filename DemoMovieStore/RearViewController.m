//
//  RearViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "RearViewController.h"
#import "AccountManager.h"
#import "Account.h"
#import "DateUtils.h"
#import "Constants.h"
#import "EditProfileViewController.h"

@interface RearViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avartarImage;

@property (weak, nonatomic) IBOutlet UILabel *txtName;

@property (weak, nonatomic) IBOutlet UILabel *txtBirthDay;

@property (weak, nonatomic) IBOutlet UILabel *txtEmail;

@property (weak, nonatomic) IBOutlet UILabel *txtGender;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *btnShowReminder;

@property (nonatomic) Account * account;

@end

@implementation RearViewController

static NSString * const formatOfDateOfBirth = @"yyyy/MM/dd";

static NSString * const segueForwardFromRearToEditProfile = @"segueForwardFromRearToEditProfile";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.account = [[AccountManager getInstance] account];
    [self setAvartarImage];
    self.txtName.text = (self.account)?self.account.name:@"Your name";
    [self setTxtBithDay];
    self.txtEmail.text = (self.account)?self.account.email:@"Your email";
    [self setGender];
    [self setBtnEdit];
    [self setBtnShowReminder];
}

- (void) setAvartarImage {
    self.avartarImage.layer.borderWidth = 1;
    self.avartarImage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.avartarImage.layer.cornerRadius = 5;
    self.avartarImage.clipsToBounds = YES;
    
    if(self.account) {
        UIImage * image = [UIImage imageWithData: self.account.avartar];
        if(image) {
            self.avartarImage.image = image;
        }
    }
    self.avartarImage.userInteractionEnabled = YES;
    UIGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAccount)];
    [self.avartarImage addGestureRecognizer: gestureRecognizer];
}

- (void) changeAccount {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Account option" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak RearViewController * weakSelf = self;
    [alertController addAction: [UIAlertAction actionWithTitle:@"Remove account" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[AccountManager getInstance] removeAccountToUserDefault];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction: [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) setTxtBithDay {
    if(self.account) {
        self.txtBirthDay.text = [DateUtils stringFromDate:self.account.dateOfBirth formatDate:formatOfDateOfBirth];
    }
    else {
        self.txtBirthDay.text = @"Your birthday";
    }
}

- (void) setGender {
    if(self.account) {
        switch (self.account.gender) {
            case MALE:
                self.txtGender.text = @"Male";
                break;
            case FEMALE:
                self.txtGender.text = @"Female";
                break;
            default:
                self.txtGender.text = @"Your gender";
                break;
        }
    }
    else {
        self.txtGender.text = @"Your gender";
    }
}

- (void) setBtnEdit {
    self.btnEdit.layer.cornerRadius = 4;
    self.btnEdit.clipsToBounds = YES;
}

- (void) setBtnShowReminder {
    self.btnShowReminder.layer.cornerRadius = 4;
    self.btnShowReminder.clipsToBounds = YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segueForwardFromRearToEditProfile isEqualToString: segue.identifier]) {
        __weak EditProfileViewController * editProfileViewController = segue.destinationViewController;
        editProfileViewController.delegate = self;
        editProfileViewController.account = self.account;
    }
}

#pragma mark <EditProfileViewControllerDelegate>

- (void) dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
