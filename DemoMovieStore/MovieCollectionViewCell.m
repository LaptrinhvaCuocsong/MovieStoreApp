#import "MovieCollectionViewCell.h"
#import "ImageHelper.h"
#import "Constants.h"
#import <UIImageView+WebCache.h>

@interface MovieCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation MovieCollectionViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
}

- (void) setMovieCollectionViewCell: (Movie * _Nonnull)movie {
    [self setMovieCollectionViewImage: movie.posterPath];
    self.title.text = movie.title;
}

- (void) setMovieCollectionViewImage: (NSString *)posterPath {
    if(!posterPath) {
        self.movieImage.image = [UIImage imageNamed:@"no-image-found"];
    }
    else {
        __weak MovieCollectionViewCell * weakSelf = self;
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
