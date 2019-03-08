#import "CastCollectionViewCell.h"
#import "ImageHelper.h"
#import "Constants.h"
#import <UIImageView+WebCache.h>

@interface CastCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *castImage;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic, weak) NSMutableArray * arrayImageURLString;

@end

@implementation CastCollectionViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.cornerRadius = 6;
}

- (void) setCastCollectionViewCell: (Cast * _Nonnull)cast imageURLString: (NSString *)imageURLString arrayImageURLString: (NSMutableArray *)arrayImageURLString {
    self.arrayImageURLString = arrayImageURLString;
    [self setCastCollectionViewImage:cast.profilePath imageURLString:imageURLString];
    self.name.text = cast.name;
}

- (void) setCastCollectionViewImage: (NSString *)profilePath imageURLString: (NSString *)imageURLString {
    if(!imageURLString) {
        if(!profilePath) {
            self.castImage.image = [UIImage imageNamed:@"no-image-found"];
        }
        else {
            __weak CastCollectionViewCell * weakSelf = self;
            [[ImageHelper getInstance] createImageURLWithImageSize:PROFILE_SIZE sizeOption:nil posterPath:profilePath success:^(NSString * _Nonnull imageURLString) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.arrayImageURLString addObject: imageURLString];
                    NSURL * url = [NSURL URLWithString: imageURLString];
                    [weakSelf.castImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"no-image-found"]];
                });
            } failure:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.castImage.image = [UIImage imageNamed:@"no-image-found"];
                });
            }];
        }
    }
    else {
        NSURL * url = [NSURL URLWithString: imageURLString];
        [self.castImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"no-image-found"]];
    }
}


@end
