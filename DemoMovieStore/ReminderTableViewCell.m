//
//  ReminderTableViewCell.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 3/4/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "ReminderTableViewCell.h"
#import "Movie.h"
#import "ImageHelper.h"
#import "DateUtils.h"
#import <UIImageView+WebCache.h>

@interface ReminderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *txtReminderDate;

@end

@implementation ReminderTableViewCell

static NSString * const formatOfReminderDate = @"yyyy/MM/dd HH:mm:ss a";

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void) setReminderTableViewCell: (Reminder * _Nonnull)reminder {
    [self setReminderTableViewImage: reminder.movie.posterPath];
    self.movieImage.layer.borderWidth = 1.0;
    self.movieImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.movieImage.layer.cornerRadius = 5;
    self.movieImage.clipsToBounds = YES;
    self.title.text = reminder.movie.title;
    self.txtReminderDate.text = [DateUtils stringFromDate:reminder.reminderDate formatDate: formatOfReminderDate];
}

- (void) setReminderTableViewImage: (NSString *)posterPath {
    if(!posterPath) {
        self.imageView.image = [UIImage imageNamed:@"no-image-found"];
    }
    else {
        __weak ReminderTableViewCell * weakSelf = self;
        [[ImageHelper getInstance] createImageURLWithImageSize:POSTER_SIZE sizeOption:nil posterPath:posterPath success:^(NSString * _Nonnull imageURLString) {
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
}

@end
