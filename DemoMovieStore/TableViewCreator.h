#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Movie.h"
#import "UITableView+Extent.h"
#import "TableViewCreatorDelegate.h"
#import "MovieItemCellDelegate.h"
#import "DetailViewControllerDelegate.h"

@interface TableViewCreator : NSObject <UITableViewDelegate, UITableViewDataSource, MovieItemCellDelegate, DetailViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<TableViewCreatorDelegate> delegate;

- (instancetype) initWithTableView: (UITableView *)tableView;

@end
