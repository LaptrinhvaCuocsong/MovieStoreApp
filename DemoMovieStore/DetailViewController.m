//
//  DetailViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/20/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "DetailViewController.h"
#import "DateUtils.h"
#import "CastCollectionViewCell.h"
#import "ImageHelper.h"
#import <UIImageView+WebCache.h>
#import "CastsCreator.h"
#import "CastsCreatorImpl.h"
#import "Cast.h"
#import "Constants.h"
#import "Reminder.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (weak, nonatomic) IBOutlet UILabel *txtReleaseDate;

@property (weak, nonatomic) IBOutlet UILabel *adult;

@property (weak, nonatomic) IBOutlet UILabel *txtRating;

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@property (weak, nonatomic) IBOutlet UITextView *movieOverview;

@property (weak, nonatomic) IBOutlet UIButton *btnReminder;

@property (weak, nonatomic) IBOutlet UITextField *txtReminder;

@property (weak, nonatomic) IBOutlet UICollectionView *actorCollectionView;

@property (nonatomic) UIAlertController * alertErrorController;

@property (nonatomic) id<CastsCreator> castsCreator;

@property (nonatomic) NSMutableArray<Cast *> * casts;

@property (nonatomic) NSMutableArray * arrayImageURLString;

@property (nonatomic) UIDatePicker * datePicker;

@end

@implementation DetailViewController

static NSString * const formatOfReleaseDate = @"yyyy/MM/dd HH:mm:ss a";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.castsCreator = [[CastsCreatorImpl alloc] init];
    
    self.casts = [[NSMutableArray alloc] init];
    
    self.arrayImageURLString = [[NSMutableArray alloc] init];
    
    [self setNavigationBar];
    
    self.navigationItem.title = self.movie.title;
    
    self.txtReleaseDate.text = [DateUtils stringFromDate:self.movie.releaseDate formatDate:formatOfReleaseDate];
    
    self.txtRating.text = [NSString stringWithFormat:@"%.1f", self.movie.voteAverage];
    
    [self setAdult];
    
    [self setMovieImage];
    
    [self setMovieOverview];
    
    [self setBtnReminder];
    
    [self setActorCollectionView];

    [self setBtnStart];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerEventTapView)];
    [self.view addGestureRecognizer: tapGestureRecognizer];
}

- (void) handlerEventTapView {
    if([self.txtReminder isFirstResponder]) {
        [self.txtReminder resignFirstResponder];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!self.movie.reminder) {
        Reminder * r = [self.delegate reminderWithMovieId: self.movie.identifier];
        if(r) {
            self.movie.reminder = r;
        }
    }
    
    [self setTxtReminder];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.movie.reminder) {
        [self.delegate addOrSetReminderMovie: self.movie.reminder];
    }
}

- (void) setNavigationBar {
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem * btnBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = btnBack;
}

- (void) back {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void) setAdult {
    if(!self.movie.adult) {
        self.adult.hidden = YES;
        // add constraint for releasedate
    }
    else {
        // add constraint for releasedate
        self.adult.layer.borderWidth = 1;
        self.adult.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.adult.layer.cornerRadius = 4;
        self.adult.clipsToBounds = YES;
    }
}

- (void) setBtnReminder {
    self.btnReminder.layer.cornerRadius = 4;
    self.btnReminder.clipsToBounds = YES;
}

- (void) setMovieOverview {
    self.movieOverview.layer.borderWidth = 0.5;
    self.movieOverview.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.movieOverview.layer.cornerRadius = 4;
    self.movieOverview.clipsToBounds = YES;
    self.movieOverview.editable = NO;
}

- (UIDatePicker *) datePicker {
    if(!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [_datePicker addTarget:self action:@selector(changeReminderDate) forControlEvents:UIControlEventValueChanged];
    }
    _datePicker.minimumDate = [[NSDate alloc] init];
    return _datePicker;
}

- (void) changeReminderDate {
    if([self.delegate isGranted]) {
        if(!self.movie.reminder) {
            self.movie.reminder = [[Reminder alloc] initWithReminderDate:self.datePicker.date movie:self.movie];
        }
        else {
            self.movie.reminder.reminderDate = self.datePicker.date;
        }
        NSString * str = [DateUtils stringFromDate:self.movie.reminder.reminderDate formatDate:formatOfReleaseDate];
        self.txtReminder.text = str;
    }
}

- (void) setTxtReminder {
    self.txtReminder.layer.borderWidth = 0.5;
    self.txtReminder.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.txtReminder.layer.cornerRadius = 4;
    self.txtReminder.clipsToBounds = YES;
    self.txtReminder.inputView = self.datePicker;
    if(self.movie.reminder) {
        self.txtReminder.text = [DateUtils stringFromDate:self.movie.reminder.reminderDate formatDate:formatOfReleaseDate];
    }
}

- (void) setMovieImage {
    __weak DetailViewController * weakSelf = self;
    [[ImageHelper getInstance] createImageURLWithImageSize:PROFILE_SIZE sizeOption:nil posterPath:weakSelf.movie.posterPath success:^(NSString * _Nonnull imageURLString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = [NSURL URLWithString: imageURLString];
            [weakSelf.movieImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"no-image-found"]];
        });
    } failure:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.movieImage.image = [UIImage imageNamed:@"no-image-found"];
        });
    }];
}

- (void) setActorCollectionView {
    self.actorCollectionView.delegate = self;
    self.actorCollectionView.dataSource = self;
    [self.actorCollectionView registerNib:[UINib nibWithNibName:CAST_COLLECTION_VIEW_CELL bundle:nil] forCellWithReuseIdentifier:CAST_COLLECTION_VIEW_CELL];
    self.actorCollectionView.backgroundColor = [UIColor whiteColor];
    self.actorCollectionView.layer.borderWidth = 1;
    self.actorCollectionView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.actorCollectionView.layer.cornerRadius = 4;
    self.actorCollectionView.clipsToBounds = YES;
    [self loadActorCollectionView];
}

- (void) loadActorCollectionView {
    __weak DetailViewController * weakSelf = self;
    [self.castsCreator createCastWithMovieId:weakSelf.movie.identifier success:^(NSMutableArray<Cast *> * _Nonnull casts) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.casts addObjectsFromArray: [NSArray arrayWithArray: casts]];
            [weakSelf.actorCollectionView reloadData];
        });
    } failure:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!weakSelf.alertErrorController) {
                weakSelf.alertErrorController = [UIAlertController alertControllerWithTitle:@"💔💔💔" message:@"We can't load cast collection" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                }];
                [weakSelf.alertErrorController addAction: cancel];
                UIAlertAction * tryAgain = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    [weakSelf loadActorCollectionView];
                }];
                [weakSelf.alertErrorController addAction: tryAgain];
            }
            [weakSelf presentViewController: weakSelf.alertErrorController animated:YES completion:nil];
        });
    }];
}

- (void) setBtnStart {
    self.btnStart.layer.borderWidth = 1;
    self.btnStart.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.btnStart.layer.cornerRadius = 4;
    self.btnStart.clipsToBounds = YES;
    if(self.movie.isFavouriteMovie) {
        [self.btnStart setBackgroundImage:[UIImage imageNamed: @"ic_star"] forState:UIControlStateNormal];
    }
    else {
        [self.btnStart setBackgroundImage:[UIImage imageNamed: @"ic_star_border"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnStartButtonPressed:(id)sender {
    if([self.delegate isGranted]) {
        if(self.movie.isFavouriteMovie) {
            self.movie.isFavouriteMovie = NO;
        }
        else {
            self.movie.isFavouriteMovie = YES;
        }
        [self setAnimationButtonStart];
        [self.delegate addOrRemoveFavouriteMovie: self.movie];
    }
}

- (void) setAnimationButtonStart {
    float borderWithOfButtonStart = self.btnStart.layer.borderWidth;
    CGRect frameOfButtonStart = self.btnStart.frame;
    CGColorRef borderColorOfButtonStart = self.btnStart.layer.borderColor;
    __weak DetailViewController * weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.btnStart.frame = CGRectMake(frameOfButtonStart.origin.x - 5, frameOfButtonStart.origin.y - 5, frameOfButtonStart.size.width + 10, frameOfButtonStart.size.height + 10);
        weakSelf.btnStart.layer.borderColor = [[UIColor redColor] CGColor];
        weakSelf.btnStart.layer.borderWidth = 2;
        if(weakSelf.movie.isFavouriteMovie) {
            [weakSelf.btnStart setBackgroundImage:[UIImage imageNamed: @"ic_star"] forState:UIControlStateNormal];
        }
        else {
            [weakSelf.btnStart setBackgroundImage:[UIImage imageNamed: @"ic_star_border"] forState:UIControlStateNormal];
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.btnStart.frame = frameOfButtonStart;
            weakSelf.btnStart.layer.borderColor = borderColorOfButtonStart;
            weakSelf.btnStart.layer.borderWidth = borderWithOfButtonStart;
        } completion:nil];
    }];
}


- (IBAction)btnReminderButtonPressed:(id)sender {
    [self.txtReminder becomeFirstResponder];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.casts.count;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CastCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CAST_COLLECTION_VIEW_CELL forIndexPath:indexPath];
    if(self.arrayImageURLString.count < (indexPath.section + 1)) {
        [cell setCastCollectionViewCell:[self.casts objectAtIndex:indexPath.section] imageURLString:nil arrayImageURLString:self.arrayImageURLString];
    }
    else {
        NSString * urlString = [self.arrayImageURLString objectAtIndex: indexPath.section];
        [cell setCastCollectionViewCell:[self.casts objectAtIndex:indexPath.section] imageURLString:urlString arrayImageURLString:self.arrayImageURLString];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightOfCollection = CGRectGetHeight(self.actorCollectionView.frame);
    CGFloat heightOfCell = heightOfCollection * 0.85;
    // auto layout for cell
    return CGSizeMake(heightOfCell, heightOfCell);
}

@end
