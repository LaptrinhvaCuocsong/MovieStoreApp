//
//  SettingViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "SettingViewController.h"
#import "SWRevealViewController.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSlide;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *txtMovieRate;

@property (weak, nonatomic) IBOutlet UITextField *txtMovieRelease;

@property (nonatomic) UIView * pickerView;

@property (nonatomic) NSMutableArray * dates;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.revealViewController) {
        [self.btnSlide setTarget: self.revealViewController];
        [self.btnSlide setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    self.txtMovieRelease.inputView = self.pickerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (UIView *) pickerView {
    if(!_pickerView) {
        CGRect frameOfPickerView = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 250);
        _pickerView = [[UIView alloc] initWithFrame: frameOfPickerView];
        UIPickerView * picker = [[UIPickerView alloc] initWithFrame: CGRectMake(10, 0, CGRectGetWidth(_pickerView.frame)-20, CGRectGetHeight(_pickerView.frame) - 50)];
        picker.layer.borderWidth = 1;
        picker.layer.cornerRadius = 5;
        picker.clipsToBounds = YES;
        picker.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        picker.backgroundColor = [UIColor whiteColor];
        [_pickerView addSubview: picker];
        picker.delegate = self;
        picker.dataSource = self;
        UIButton * btnCancel = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        btnCancel.titleLabel.text = @"Cancel";
        btnCancel.frame = CGRectMake(0, CGRectGetHeight(_pickerView.frame)-55, CGRectGetWidth(_pickerView.frame)/2 - 10, 40);
        btnCancel.backgroundColor = [UIColor redColor];
        [_pickerView addSubview: btnCancel];
        UIButton * btnDone = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        btnDone.titleLabel.text = @"Done";
        btnDone.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 + 10, CGRectGetHeight(_pickerView.frame)-55, CGRectGetWidth(_pickerView.frame)/2 - 10, 40);
        btnDone.backgroundColor = [UIColor blueColor];
        [_pickerView addSubview: btnDone];
    }
    return _pickerView;
}

- (NSMutableArray *) dates {
    if(!_dates) {
        _dates = [[NSMutableArray alloc] init];
        NSDate * date = [[NSDate date] init];
        NSCalendar * calendar = [NSCalendar currentCalendar];
        NSInteger currentYear = [calendar component:NSCalendarUnitYear fromDate:date];
        for(NSInteger i = 1970; i <= currentYear; i++) {
            [_dates addObject: [NSNumber numberWithInteger: i]];
        }
    }
    return _dates;
}

#pragma mark <UITableViewDelegate>

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row < 4) {
            [self setAccessoryTypeForCellsFilterMovies:tableView row:indexPath.row];
        }
        else if(indexPath.row == 5) {
            [self showDatePicker];
        }
    }
    else {
        [self setAccessoryTypeForCellsSortMovie:tableView row:indexPath.row];
    }
}

- (void) showDatePicker {
    [self.txtMovieRelease becomeFirstResponder];
}

- (void) setAccessoryTypeForCellsFilterMovies:(UITableView *)tableView row:(NSInteger)row {
    for(NSInteger i = 0; i < 4; i++) {
        if(i != row) {
            UITableViewCell * cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    UITableViewCell * cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void) setAccessoryTypeForCellsSortMovie:(UITableView *)tableView  row:(NSInteger)row {
    for(NSInteger i = 0; i < 2; i++) {
        if(i != row) {
            UITableViewCell * cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    UITableViewCell * cell = [tableView.dataSource tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark <UIPickerViewDataSource>


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dates.count;
}

#pragma mark <UIPickerViewDelegate>

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@", self.dates[row]];
}

@end
