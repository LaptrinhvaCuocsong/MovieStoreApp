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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBetweenTxtReleaseDateAndBtnAdult;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBetweenTxtReleaseDateAndBtnStart;


@property (nonatomic) NSMutableArray * arrayImageURLString;

@property (nonatomic) Movie * movie;

@property (nonatomic) NSMutableString * urlString;

@end

@implementation MovieItemCell

static float LAYOUT_PRIORITY_NON_REQUIRED = 1;

static float LAYOUT_PRIORITY_REQUIRED = 99;

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
    self.movie = movie;
    self.movieTitle.text = movie.title;
    self.arrayImageURLString = arrayImageURLString;
    [self setMovieItemImage: imageURLString];
    self.releaseDate.text = [DateUtils stringFromDate:movie.releaseDate formatDate:formatOfReleaseDate];
    self.rating.text = [NSString stringWithFormat:@"%.1f", movie.voteAverage];
    [self setTxtAdult: movie.adult];
    self.overview.text = movie.overview;
}

- (void) setTxtAdult: (BOOL)adult {
    if(!adult) {
        [self.adult removeFromSuperview];
        self.constraintBetweenTxtReleaseDateAndBtnStart.priority = LAYOUT_PRIORITY_REQUIRED;
    }
    else {
        self.constraintBetweenTxtReleaseDateAndBtnStart.priority = LAYOUT_PRIORITY_NON_REQUIRED;
        self.constraintBetweenTxtReleaseDateAndBtnAdult.priority = LAYOUT_PRIORITY_REQUIRED;
        self.adult.layer.borderWidth = 1;
        self.adult.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.adult.layer.cornerRadius = 4;
        self.adult.clipsToBounds = YES;
    }
}

- (void) setMovieItemImage: (NSString *)imageURLString {
    if(!imageURLString) {
        if(!self.movie.posterPath) {
            self.movieImage.image = [UIImage imageNamed:@"no-image-found"];
        }
        else {
            __weak MovieItemCell * weakSelf = self;
            [[ImageHelper getInstance] createImageURLWithImageSize:POSTER_SIZE sizeOption:nil posterPath:weakSelf.movie.posterPath success:^(NSString * _Nonnull imageURLString) {
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

- (IBAction)btnStartButtonPressed:(id)sender {
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
