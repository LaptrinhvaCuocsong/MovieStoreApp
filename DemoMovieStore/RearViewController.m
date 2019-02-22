//
//  RearViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "RearViewController.h"

@interface RearViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avartarImage;

@property (weak, nonatomic) IBOutlet UILabel *txtName;

@property (weak, nonatomic) IBOutlet UILabel *txtBirthDay;

@property (weak, nonatomic) IBOutlet UILabel *txtEmail;

@property (weak, nonatomic) IBOutlet UILabel *txtGender;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *btnShowReminder;

@end

@implementation RearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAvartarImage];
}

- (void) setAvartarImage {
    self.avartarImage.layer.borderWidth = 1;
    self.avartarImage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.avartarImage.layer.cornerRadius = 5;
    self.avartarImage.clipsToBounds = YES;
}

@end
