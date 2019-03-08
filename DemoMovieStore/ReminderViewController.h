#import <UIKit/UIKit.h>
#import "TabItemViewController.h"
#import "Reminder.h"
#import "DetailViewControllerDelegate.h"

@interface ReminderViewController : TabItemViewController <UITableViewDelegate, UITableViewDataSource, DetailViewControllerDelegate>

@end
