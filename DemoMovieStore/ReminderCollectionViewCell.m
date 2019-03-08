#import "ReminderCollectionViewCell.h"
#import "ImageHelper.h"
#import "DateUtils.h"
#import <UIImageView+WebCache.h>
#import "Movie.h"

@interface ReminderCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *txtReminderDate;

@end

@implementation ReminderCollectionViewCell

static NSString * const formatOfReminderDate = @"yyyy/MM/dd HH:mm:ss a";

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void) setReminderCollectionViewCell: (Reminder * _Nonnull)reminder {
    [self setReminderCollectionViewImage: reminder.movie.posterPath];
    self.title.text = reminder.movie.title;
    self.txtReminderDate.text = [DateUtils stringFromDate:reminder.reminderDate formatDate: formatOfReminderDate];
}

- (void) setReminderCollectionViewImage: (NSString *)posterPath {
    if(!posterPath) {
        self.imageView.image = [UIImage imageNamed:@"no-image-found"];
    }
    else {
        __weak ReminderCollectionViewCell * weakSelf = self;
        [[ImageHelper getInstance] createImageURLWithImageSize:POSTER_SIZE sizeOption:nil posterPath:posterPath success:^(NSString * _Nonnull imageURLString) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL * url = [NSURL URLWithString: imageURLString];
                [weakSelf.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"no-image-found"]];
            });
        } failure:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.imageView.image = [UIImage imageNamed:@"no-image-found"];
            });
        }];
    }
}

@end
