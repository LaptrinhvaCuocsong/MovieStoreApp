//
//  MovieItemCell.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "MovieItemCell.h"
#import "Constants.h"
#import "ImageHelper.h"
#import <UIImageView+WebCache.h>
#import "DateUtils.h"

@interface MovieItemCell()

@property (weak, nonatomic) IBOutlet UILabel *movieTitle;

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@property (weak, nonatomic) IBOutlet UILabel *releaseDate;

@property (weak, nonatomic) IBOutlet UILabel *rating;

@property (weak, nonatomic) IBOutlet UILabel *adult;

@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (weak, nonatomic) IBOutlet UILabel *overview;

@property (nonatomic, weak) NSMutableArray * arrayImageURLString;

@property (nonatomic) NSMutableString * urlString;

@end

@implementation MovieItemCell

static NSString * const formatOfReleaseDate = @"yyyy-MM-dd";

- (void)awakeFromNib {
    [super awakeFromNib];
    self.adult.layer.cornerRadius = 4;
    self.adult.clipsToBounds = YES;
    self.btnStart.layer.borderWidth = 1;
    self.btnStart.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.btnStart.layer.cornerRadius = 4;
    self.btnStart.clipsToBounds = YES;
}

- (void) setMovieItemCell: (Movie * _Nonnull)movie imageURLString: (NSString *)imageURLString arrayImageURLString: (NSMutableArray *)arrayImageURLString {
    self.movieTitle.text = movie.title;
    self.arrayImageURLString = arrayImageURLString;
    [self setMovieItemImage: movie.posterPath imageURLString: imageURLString];
    self.releaseDate.text = [DateUtils stringFromDate:movie.releaseDate formatDate:formatOfReleaseDate];
    self.rating.text = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
    if(!movie.adult) {
        self.adult.hidden = YES;
        // add constraint for releasedate
    }
    else {
        // add constraint for releasedate
        self.adult.layer.borderWidth = 1;
        self.adult.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.adult.layer.cornerRadius = 4;
        self.adult.clipsToBounds = YES;
    }
    self.overview.text = movie.overview;
}

- (void) setMovieItemImage: (NSString *)posterPath imageURLString: (NSString *)imageURLString {
    if(!imageURLString) {
        if(!posterPath) {
            self.movieImage.image = [UIImage imageNamed:@"no-image-found"];
        }
        else {
            __weak MovieItemCell * weakSelf = self;
            [[ImageHelper getInstance] createImageURLWithImageSize:POSTER_SIZE sizeOption:nil posterPath:posterPath success:^(NSString * _Nonnull imageURLString) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.arrayImageURLString addObject: imageURLString];
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
    else {
        NSURL * url = [NSURL URLWithString: imageURLString];
        [self.movieImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"no-image-found"]];
    }
}

- (IBAction)addMovieFavorite:(id)sender {
    [self setAnimationButtonStart];
}

- (void) setAnimationButtonStart {
    float borderWithOfButtonStart = self.btnStart.layer.borderWidth;
    CGRect frameOfButtonStart = self.btnStart.frame;
    CGColorRef borderColorOfButtonStart = self.btnStart.layer.borderColor;
    __weak MovieItemCell * weakSelf = self;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.btnStart.frame = CGRectMake(frameOfButtonStart.origin.x - 5, frameOfButtonStart.origin.y - 5, frameOfButtonStart.size.width + 10, frameOfButtonStart.size.height + 10);
        weakSelf.btnStart.layer.borderColor = [[UIColor redColor] CGColor];
        weakSelf.btnStart.layer.borderWidth = 2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.btnStart.frame = frameOfButtonStart;
            weakSelf.btnStart.layer.borderColor = borderColorOfButtonStart;
            weakSelf.btnStart.layer.borderWidth = borderWithOfButtonStart;
        } completion:nil];
    }];
}

@end
