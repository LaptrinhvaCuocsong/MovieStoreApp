#import "SettingViewController.h"
#import "SWRevealViewController.h"
#import "AccountManager.h"
#import "NSMutableDictionary+SettingOfAccount.h"
#import "Constants.h"
#import "DateUtils.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSlide;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *txtMovieRate;

@property (weak, nonatomic) IBOutlet UITextField *txtMovieRelease;

@property (nonatomic) UIView * pickerView;

@property (nonatomic) NSMutableArray * dates;

@property (nonatomic) UIButton * btnDelete;

@property (nonatomic) UIButton * btnDone;

@property (nonatomic) NSMutableDictionary * settingOfAccount;

@property (nonatomic) NSInteger indexOfCellFilterHaveAccessory;

@property (nonatomic) NSInteger indexOfCellSortHaveAccessory;

@property (nonatomic) BOOL haveChangeSetting;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.revealViewController) {
        [self.btnSlide setTarget: self.revealViewController];
        [self.btnSlide setAction: @selector(revealToggle:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    self.haveChangeSetting = NO;
    
    self.settingOfAccount = [[AccountManager getInstance] settingOfAccount];
    if(!self.settingOfAccount) {
        self.settingOfAccount = [[NSMutableDictionary alloc] init];
        [self.settingOfAccount setUrlString: API_GET_MOVIE_POPULAR_LIST];
    }
    
    [self setSlider];
    
    self.txtMovieRate.text = [NSString stringWithFormat: @"%.1f", [self.settingOfAccount movieRate]];
    
    [self setTxtMovieRelease];
    
    self.indexOfCellFilterHaveAccessory = [self indexOfCellFromUrlString: [self.settingOfAccount urlString]];
    
    self.indexOfCellSortHaveAccessory = [self indexOfCellFromTypeOfSort: [self.settingOfAccount typeOfSort]];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([self.txtMovieRate.text floatValue] != [self.settingOfAccount movieRate]) {
        [self.settingOfAccount setMovieRate: [self.txtMovieRate.text floatValue]];
        self.haveChangeSetting = YES;
    }
    
    if([self.txtMovieRelease.text integerValue] != [self.settingOfAccount releaseYear]) {
        [self.settingOfAccount setReleaseYear: [self.txtMovieRelease.text integerValue]];
    }
    
    if(self.haveChangeSetting) {
        [[AccountManager getInstance] setSettingOfAccount: self.settingOfAccount];
        [[NSNotificationCenter defaultCenter] postNotificationName:DID_CHANGE_SETTING object:nil];
    }
}

- (void) setSlider {
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 10.0;
    [self.slider setValue:[self.settingOfAccount movieRate]];
    [self.slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
}

- (void) sliderValueChange {
    self.txtMovieRate.text = [NSString stringWithFormat:@"%.1f", self.slider.value];
}

- (void) setTxtMovieRelease {
    if([self.settingOfAccount releaseYear]) {
        self.txtMovieRelease.text = [NSString stringWithFormat: @"%ld", [self.settingOfAccount releaseYear]];
    }
    else {
        self.txtMovieRelease.text = @"1970";
    }
    
    self.txtMovieRelease.inputView = self.pickerView;
}

- (NSInteger) indexOfCellFromUrlString: (NSString *)urlString {
    if([API_GET_MOVIE_POPULAR_LIST isEqualToString: urlString]) {
        return 0;
    }
    else if([API_GET_MOVIE_TOP_RATE_LIST isEqualToString: urlString]) {
        return 1;
    }
    else if([API_GET_MOVIE_UP_COMMING_LIST isEqualToString: urlString]) {
        return 2;
    }
    else if([API_GET_MOVIE_NOW_PLAYING isEqualToString: urlString]) {
        return 3;
    }
    return -1;
}

- (NSInteger) indexOfCellFromTypeOfSort: (TYPE_OF_SORT)typeOfSort {
    switch (typeOfSort) {
        case RELEASE_DATE_SORT:
            return 0;
        case RATING_SORT:
            return 1;
        default:
            return -1;
    }
}

- (UIView *) pickerView {
    if(!_pickerView) {
        _pickerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 280)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.layer.borderWidth = 1;
        _pickerView.layer.cornerRadius = 5;
        _pickerView.clipsToBounds = YES;
        _pickerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        UIPickerView * picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(_pickerView.frame), CGRectGetHeight(_pickerView.frame) - 60)];
        [_pickerView addSubview: picker];
        [_pickerView addSubview: self.btnDelete];
        [_pickerView addSubview: self.btnDone];
        
        picker.delegate = self;
        picker.dataSource = self;
    }
    return _pickerView;
}

- (UIButton *) btnDelete {
    if(!_btnDelete) {
        _btnDelete = [UIButton buttonWithType: UIButtonTypeCustom];
        _btnDelete.frame = CGRectMake(0, CGRectGetHeight(_pickerView.frame)-50, CGRectGetWidth(_pickerView.frame)/2 - 10, 50);
        _btnDelete.backgroundColor = [UIColor redColor];
        [_btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [_btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnDelete.layer.cornerRadius = 5;
        _btnDelete.clipsToBounds = YES;
        [_btnDelete addTarget:self action:@selector(btnDeleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDelete;
}

- (void) btnDeleteButtonPressed {
    UIColor * currentColor = [self.btnDelete titleColorForState: UIControlStateNormal];
    __weak SettingViewController * weakSelf = self;
    [UIView animateWithDuration:0.02 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.btnDelete.layer.opacity = 0.5;
        [weakSelf.btnDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.02 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.btnDelete.layer.opacity = 1.0;
            [weakSelf.btnDelete setTitleColor:currentColor forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            weakSelf.txtMovieRelease.text = @"";
        }];
    }];
}

- (UIButton *) btnDone {
    if(!_btnDone) {
        _btnDone = [UIButton buttonWithType: UIButtonTypeCustom];
        _btnDone.frame = CGRectMake(CGRectGetWidth(_pickerView.frame)/2 + 10, CGRectGetHeight(_pickerView.frame)-50, CGRectGetWidth(_pickerView.frame)/2 - 10, 50);
        _btnDone.backgroundColor = [UIColor blueColor];
        [_btnDone setTitle:@"Done" forState:UIControlStateNormal];
        [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnDone.layer.cornerRadius = 5;
        _btnDone.clipsToBounds = YES;
        [_btnDone addTarget: self action:@selector(btnDoneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnDone;
}

- (void) btnDoneButtonPressed {
    UIColor * currentColor = [self.btnDone titleColorForState: UIControlStateNormal];;
    __weak SettingViewController * weakSelf = self;
    [UIView animateWithDuration:0.02 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.btnDone.layer.opacity = 0.5;
        [weakSelf.btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.02 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            weakSelf.btnDone.layer.opacity = 1.0;
            [weakSelf.btnDone setTitleColor:currentColor forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            [weakSelf.txtMovieRelease resignFirstResponder];
        }];
    }];
}

- (NSMutableArray *) dates {
    if(!_dates) {
        _dates = [[NSMutableArray alloc] init];
        NSDate * date = [[NSDate date] init];
        NSInteger currentYear = [DateUtils yearFromDate: date];
        for(NSInteger i = 1970; i <= currentYear; i++) {
            [_dates addObject: [NSNumber numberWithInteger: i]];
        }
    }
    return _dates;
}

- (NSString *) urlStringFromIndexOfCellFilter: (NSInteger)indexOfCellFilter {
    switch (indexOfCellFilter) {
        case 0:
            return API_GET_MOVIE_POPULAR_LIST;
        case 1:
            return API_GET_MOVIE_TOP_RATE_LIST;
        case 2:
            return API_GET_MOVIE_UP_COMMING_LIST;
        default:
            return API_GET_MOVIE_NOW_PLAYING;
    }
}

- (TYPE_OF_SORT) typeOfSortFromIndexOfCellSort: (NSInteger)indexOfCellSort {
    switch (indexOfCellSort) {
        case 0:
            return RELEASE_DATE_SORT;
        default:
            return RATING_SORT;
    }
}

#pragma mark <UITableViewDelegate>

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == self.indexOfCellFilterHaveAccessory) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        if(indexPath.row == self.indexOfCellSortHaveAccessory) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row < 4) {
            [self setAccessoryTypeForCellsFilterMovies:tableView row:indexPath.row];
            NSString * str = [self urlStringFromIndexOfCellFilter: indexPath.row];
            if(![str isEqualToString: [self.settingOfAccount urlString]]) {
                [self.settingOfAccount setUrlString: str];
                self.haveChangeSetting = YES;
            }
        }
        else if(indexPath.row == 5) {
            [self showDatePicker];
        }
    }
    else {
        [self setAccessoryTypeForCellsSortMovie:tableView row:indexPath.row];
        TYPE_OF_SORT typeOfSort = [self typeOfSortFromIndexOfCellSort: indexPath.row];
        if(typeOfSort != [self.settingOfAccount typeOfSort]) {
            [self.settingOfAccount setTypeOfSort: [self typeOfSortFromIndexOfCellSort: indexPath.row]];
            self.haveChangeSetting = YES;
        }
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

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.txtMovieRelease.text = [NSString stringWithFormat:@"%@", self.dates[row]];
}

@end
