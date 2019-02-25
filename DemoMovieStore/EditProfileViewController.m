//
//  EditProfileViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/22/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "EditProfileViewController.h"
#import "DateUtils.h"
#import "Constants.h"
#import "AccountMO+CoreDataClass.h"
#import "AccountManager.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControlGender;

@property (nonatomic) UIAlertController * alertErrorController;

@property (nonatomic) UIAlertController * alertActivityController;

@property (nonatomic) UIDatePicker * datePicker;

@end

@implementation EditProfileViewController

static NSString * formatOfDateOfBirth = @"yyyy/MM/dd";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAvatar];
    [self setTxtName];
    [self setTxtBirthday];
    [self setTxtEmail];
    [self setBtnCancel];
    [self setBtnDone];
    [self setSegmentedControlGender];
    
    UITapGestureRecognizer * tapGestureReconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerEventTapView)];
    [self.view addGestureRecognizer: tapGestureReconizer];
}

- (void) handlerEventTapView {
    if([self.txtBirthday isFirstResponder]) {
        [self.txtBirthday resignFirstResponder];
    }
    if([self.txtEmail isFirstResponder]) {
        [self.txtEmail resignFirstResponder];
    }
    if([self.txtName isFirstResponder]) {
        [self.txtName resignFirstResponder];
    }
}

- (void) setAvatar {
    self.avatar.layer.borderWidth = 1;
    self.avatar.layer.borderColor = [[UIColor grayColor] CGColor];
    self.avatar.layer.cornerRadius = 5;
    self.avatar.clipsToBounds = YES;
    if(self.account) {
        UIImage * image = [UIImage imageWithData: self.account.avartar];
        if(image) {
            self.avatar.image = image;
        }
    }
    UIGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAvartarImageFromDevice)];
    self.avatar.userInteractionEnabled = YES;
    [self.avatar addGestureRecognizer: tapGestureRecognizer];
}

- (UIAlertController *) alertErrorController {
    if(!_alertErrorController) {
        _alertErrorController = [UIAlertController alertControllerWithTitle:@"😥😥😥" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [_alertErrorController addAction: [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    }
    return _alertErrorController;
}

- (UIAlertController *) alertActivityController {
    if(!_alertActivityController) {
        _alertActivityController = [UIAlertController alertControllerWithTitle:@"" message:@"Waiting ..." preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        CGRect frameOfActivity = activityIndicator.frame;
        frameOfActivity.origin.x = 25;
        frameOfActivity.origin.y = 17.5;
        activityIndicator.frame = frameOfActivity;
        [_alertActivityController.view addSubview: activityIndicator];
        [activityIndicator startAnimating];
    }
    return _alertActivityController;
}

- (void) chooseAvartarImageFromDevice {
    UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"Options" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak EditProfileViewController *weakSelf = self;
    [alertViewController addAction: [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
        }
        else {
            weakSelf.alertErrorController.message = @"our device is not compatible with this process";
            [weakSelf presentViewController:weakSelf.alertErrorController animated:YES completion:nil];
        }
    }]];
    [alertViewController addAction: [UIAlertAction actionWithTitle:@"Photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController * imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = YES;
            [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
        }
        else {
            weakSelf.alertErrorController.message = @"our device is not compatible with this process";
            [weakSelf presentViewController:weakSelf.alertErrorController animated:YES completion:nil];
        }
    }]];
    [alertViewController addAction: [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertViewController animated:YES completion:nil];
}

- (void) setTxtName {
    self.txtName.text = (self.account)?self.account.name:@"";
    self.txtName.delegate = self;
}

- (UIDatePicker *) datePicker {
    if(!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(changeValueOfTxtBirthday) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (void) changeValueOfTxtBirthday {
    self.txtBirthday.text = [DateUtils stringFromDate:self.datePicker.date formatDate:formatOfDateOfBirth];
}

- (void) setTxtBirthday {
    if(self.account) {
        self.txtBirthday.text = [DateUtils stringFromDate:self.account.dateOfBirth formatDate:formatOfDateOfBirth];;
    }
    else {
        self.txtBirthday.text = @"";
    }
    self.txtBirthday.inputView = self.datePicker;
}

- (void) setTxtEmail {
    self.txtEmail.text = (self.account)?self.account.email:@"";
    self.txtEmail.delegate = self;
}

- (void) setSegmentedControlGender {
    if(self.account) {
        switch (self.account.gender) {
            case MALE:
                self.segmentedControlGender.selectedSegmentIndex = MALE;
                break;
            case FEMALE:
                self.segmentedControlGender.selectedSegmentIndex = FEMALE;
        }
    }
}

- (void) setBtnCancel {
    self.btnCancel.layer.cornerRadius = 4;
    self.btnCancel.clipsToBounds = YES;
}

- (IBAction)btnCancelButtonPressed:(id)sender {
    [self.delegate dismissViewController];
}

- (void) setBtnDone {
    self.btnDone.layer.cornerRadius = 4;
    self.btnDone.clipsToBounds = YES;
}

- (IBAction)btnDoneButtonPressed:(id)sender {
    NSMutableString * message = [[NSMutableString alloc] init];
    NSString * name = self.txtName.text;
    if([@"" isEqualToString: name]) {
        [message appendString:@"Name is required. "];
    }
    NSString * birthday = self.txtBirthday.text;
    if([@"" isEqualToString: birthday]) {
        [message appendString: @"Birthday is required. "];
    }
    NSString * email = self.txtEmail.text;
    if([@"" isEqualToString: email]) {
        [message appendString: @"Email is required."];
    }
    else {
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"\\w+@\\w+\\.\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRange range = NSMakeRange(0, email.length);
        NSRange rangeOfMatch = [regex rangeOfFirstMatchInString:email options:0 range:range];
        if(!NSEqualRanges(rangeOfMatch, range)) {
            [message appendString: @"Email format is yyyy/MM/dd"];
        }
    }
    GENDER gender = self.segmentedControlGender.selectedSegmentIndex;
    if(![@"" isEqualToString: message]) {
        self.alertErrorController.title = @"💔💔💔";
        self.alertErrorController.message = message;
        [self presentViewController: self.alertErrorController animated:YES completion:nil];
    }
    else {
        NSDate * dateOfBirth = [DateUtils dateFromDateString:birthday formatDate:formatOfDateOfBirth];
        NSData * data = UIImagePNGRepresentation(self.avatar.image);
        Account * account = [[Account alloc] initWithName:name dateOfBirth:dateOfBirth email:email gender:gender avartar:data];
        if(self.account) {
            // set identifier for account
            account.indentifier = self.account.indentifier;
            [self presentViewController:self.alertActivityController animated:YES completion:nil];
            __weak EditProfileViewController * weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                BOOL isSaved = [AccountMO updateAccount: account];
                if(isSaved) {
                    [[AccountManager getInstance] setAccount: account];
                    [[AccountManager getInstance] saveAccountToUserDefault];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                        weakSelf.alertErrorController.message = @"Save error";
                        [weakSelf presentViewController:weakSelf.alertErrorController animated:YES completion:nil];
                    });
                }
            });
        }
        else {
            [self presentViewController:self.alertActivityController animated:YES completion:nil];
            __weak EditProfileViewController * weakSelf = self;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                // insert and set identifier for account
                BOOL isInserted = [AccountMO insertNewAccount: account];
                if(isInserted) {
                    [[AccountManager getInstance] setAccount: account];
                    [[AccountManager getInstance] saveAccountToUserDefault];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                        weakSelf.alertErrorController.message = @"Save error";
                        [weakSelf presentViewController:weakSelf.alertErrorController animated:YES completion:nil];
                    });
                }
            });
        }
    }
}

#pragma mark <UIImagePickerControllerDelegate>

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image = [info objectForKey: UIImagePickerControllerOriginalImage];
    if(image) {
        self.avatar.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UITextFieldDelegate>

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
