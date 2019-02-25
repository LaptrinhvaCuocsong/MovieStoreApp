//
//  TableViewCreator.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Movie.h"
#import "UITableView+Extent.h"
#import "TableViewCreatorDelegate.h"
#import "MovieItemCellDelegate.h"

@interface TableViewCreator : NSObject <UITableViewDelegate, UITableViewDataSource, MovieItemCellDelegate>

@property (nonatomic, weak) id<TableViewCreatorDelegate> delegate;

- (instancetype) initWithTableView: (UITableView *)tableView;

@end
