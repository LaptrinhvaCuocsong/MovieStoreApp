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
#import "ReminderCollectionViewCell.h"
#import "Constants.h"
#import "SettingViewController.h"
#import "SWRevealViewController.h"
#import "ReminderViewController.h"

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

@property (nonatomic) NSArray<Reminder *> * reminderMoves;

@end

@implementation RearViewController

static NSString * const formatOfDateOfBirth = @"yyyy/MM/dd";

static NSString * const segueForwardFromRearToEditProfile = @"segueForwardFromRearToEditProfile";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setViewForController) name:DID_REMOVE_ACCOUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setViewForController) name:DID_SAVE_ACCOUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(handlerEventRemoveReminder) name:DID_REMOVE_REMINDER object:nil];
    
    [self setCollectionView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setReminderMovies];
    
    [self setViewForController];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void) handlerEventRemoveReminder {
    self.account = [[AccountManager getInstance] account];
    
    [self setReminderMovies];
    
    [self.collectionView reloadData];
}

- (void) setViewForController {
    self.account = [[AccountManager getInstance] account];
    
    [self setAvartarImage];
    self.txtName.text = (self.account)?self.account.name:@"Your name";
    [self setTxtBithDay];
    self.txtEmail.text = (self.account)?self.account.email:@"Your email";
    [self setGender];
    [self setBtnEdit];
    [self setBtnShowReminder];
    
    [self setReminderMovies];
    
    [self.collectionView reloadData];
}

- (void) setReminderMovies {
    self.reminderMoves = nil;
    
    if(self.account) {
        if(self.account.reminderMovies) {
            NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reminderDate" ascending:YES];
            NSArray<NSSortDescriptor *> * array = @[sortDescriptor];
            self.reminderMoves = [self.account.reminderMovies sortedArrayUsingDescriptors: array];
        }
    }
}

- (void) setCollectionView {
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.collectionView.layer.cornerRadius = 5;
    self.collectionView.clipsToBounds = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:REMINDER_COLLECTION_VIEW_CELL bundle:nil] forCellWithReuseIdentifier:REMINDER_COLLECTION_VIEW_CELL];
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
    else {
        self.avartarImage.image = [UIImage imageNamed: @"ic-person"];
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName: DID_REMOVE_ACCOUNT object: nil];
        
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
        editProfileViewController.account = self.account;
    }
}

- (IBAction)btnShowReminderButtonPressed:(id)sender {
    [self.revealViewController revealToggle: sender];
    UITabBarController * tabBarViewController = (UITabBarController *)self.revealViewController.frontViewController;
    UINavigationController * navigationController = [tabBarViewController.viewControllers objectAtIndex:2];
    tabBarViewController.selectedViewController = navigationController;
    UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReminderViewController * reminderViewController = [mainStoryBoard instantiateViewControllerWithIdentifier: REMINDER_VIEW_CONTROLLER_MAIN_STORYBOARD];
    NSDictionary * dic = @{@"navigationController": navigationController, @"reminderViewController":reminderViewController};
    [self performSelector:@selector(pushReminderViewController:) withObject:dic afterDelay:0.5];
}

- (void) pushReminderViewController: (NSDictionary *)dic {
    UINavigationController * navigationController = dic[@"navigationController"];
    ReminderViewController * reminderViewController = dic[@"reminderViewController"];
    [navigationController pushViewController:reminderViewController animated:YES];
}

#pragma mark <EditProfileViewControllerDelegate>

- (void) dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.reminderMoves) {
        NSInteger count = [self.reminderMoves count];
        return (count > 2)?2:count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReminderCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:REMINDER_COLLECTION_VIEW_CELL forIndexPath:indexPath];
    [cell setReminderCollectionViewCell: [self.reminderMoves objectAtIndex: indexPath.item]];
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame)/2 - 5);
}

@end
