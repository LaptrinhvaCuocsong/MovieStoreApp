#import <Foundation/Foundation.h>

@interface ImageConfiguration : NSObject

@property (nonatomic) NSString * secureBaseURL;

@property (nonatomic) NSArray<NSString *> * backdropSizes;

@property (nonatomic) NSArray<NSString *> * logoSizes;

@property (nonatomic) NSArray<NSString *> * posterSizes;

@property (nonatomic) NSArray<NSString *> * profileSizes;

@property (nonatomic) NSArray<NSString *> * stillSizes;

@end
