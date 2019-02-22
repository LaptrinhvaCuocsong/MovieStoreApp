//
//  MovieCollectionViewCell.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/20/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "MovieCollectionViewCell.h"
#import "ImageHelper.h"
#import "Constants.h"
#import <UIImageView+WebCache.h>

@interface MovieCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic, weak) NSMutableArray * arrayImageURLString;

@end

@implementation MovieCollectionViewCell

- (void) awakeFromNib {
    [super awakeFromNib];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
}

- (void) setMovieCollectionViewCell: (Movie * _Nonnull)movie imageURLString: (NSString *)imageURLString arrayImageURLString: (NSMutableArray *)arrayImageURLString {
    self.arrayImageURLString = arrayImageURLString;
    [self setMovieCollectionViewImage: movie.posterPath imageURLString: imageURLString];
    self.title.text = movie.title;
}

- (void) setMovieCollectionViewImage: (NSString *)posterPath imageURLString: (NSString *)imageURLString {
    if(!imageURLString) {
        if(!posterPath) {
            self.movieImage.image = [UIImage imageNamed:@"no-image-found"];
        }
        else {
            __weak MovieCollectionViewCell * weakSelf = self;
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

@end
