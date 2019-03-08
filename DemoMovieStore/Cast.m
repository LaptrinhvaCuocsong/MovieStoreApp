#import "Cast.h"

@implementation Cast

- (instancetype) initWithIdentifier: (NSUInteger)identifier name: (NSString *)name profilePath: (NSString *)profilePath {
    self = [super init];
    if(self) {
        self.identifier = identifier;
        self.name = name;
        self.profilePath = profilePath;
    }
    return self;
}

@end
