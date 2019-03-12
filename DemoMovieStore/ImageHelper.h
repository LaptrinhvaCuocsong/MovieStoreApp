#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ImageHelper : NSObject

+ (instancetype _Nonnull) getInstance;

- (void) createImageURLWithImageSize: (IMAGE_SIZE)imageSize sizeOption: (NSString * _Nullable)sizeOption posterPath: (NSString * _Nonnull)posterPath success: (void(^ _Nonnull)(NSString * _Nonnull imageURLString))success failure: (void(^ _Nonnull)(void))failure;

@end
