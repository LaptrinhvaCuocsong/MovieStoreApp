//
//  ReminderViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 3/4/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderTableViewCell.h"
#import "Account.h"
#import "AccountManager.h"
#import "Reminder.h"
#import "Constants.h"

@interface ReminderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) Account * account;

@property (nonatomic) NSMutableArray<Reminder *> * reminderMovies;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:REMINDER_TABLE_VIEW_CELL bundle:nil] forCellReuseIdentifier:REMINDER_TABLE_VIEW_CELL];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.account = [[AccountManager getInstance] account];
    if(self.account) {
        if(self.account.reminderMovies) {
            NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reminderDate" ascending:YES];
            NSArray * array = @[sortDescriptor];
            NSArray<Reminder *> * arraySorted = [self.account.reminderMovies sortedArrayUsingDescriptors: array];
            if(arraySorted) {
                self.reminderMovies = [NSMutableArray arrayWithArray: arraySorted];
            }
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark <UITableViewDataSource>

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.reminderMovies) {
        return self.reminderMovies.count;
    }
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReminderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:REMINDER_TABLE_VIEW_CELL forIndexPath:indexPath];
    [cell setReminderTableViewCell: [self.reminderMovies objectAtIndex: indexPath.row]];
    return cell;
}

#pragma mark <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.0;
}

@end
