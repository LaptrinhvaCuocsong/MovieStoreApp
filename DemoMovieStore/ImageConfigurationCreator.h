#import <Foundation/Foundation.h>
#import "ImageConfiguration.h"

@protocol ImageConfigurationCreator <NSObject>

- (void) createImageConfiguration: (void(^ _Nonnull)(ImageConfiguration * _Nonnull imageConfiguration))success failure: (void(^ _Nonnull)(void))failure;

@end
