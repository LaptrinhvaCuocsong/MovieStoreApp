#import <Foundation/Foundation.h>

@interface Cast : NSObject

@property (nonatomic) NSUInteger identifier;

@property (nonatomic) NSString * name;

@property (nonatomic) NSString * profilePath;

- (instancetype) initWithIdentifier: (NSUInteger)identifier name: (NSString *)name profilePath: (NSString *)profilePath;

@end
