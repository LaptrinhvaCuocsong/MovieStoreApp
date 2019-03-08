#import "ImageConfigurationCreatorImpl.h"
#import <AFNetworking.h>
#import "MyNetworking.h"
#import "Constants.h"
#import "NSDictionary+ImageConfiguration.h"

@implementation ImageConfigurationCreatorImpl

static NSString * const API_GET_BASE_URL_IMAGE = @"https://api.themoviedb.org/3/configuration?api_key=e7631ffcb8e766993e5ec0c1f4245f93";

- (void) createImageConfiguration: (void(^)(ImageConfiguration *))success failure: (void(^)(void))failure {
    AFHTTPSessionManager * sessionManager = [[MyNetworking getInstance] afHttpSessionManager: nil];
    [sessionManager GET:API_GET_BASE_URL_IMAGE parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary * obj = (NSMutableDictionary *)responseObject;
        NSMutableDictionary * images = obj[@"images"];
        ImageConfiguration * imageConfiguration = [[ImageConfiguration alloc] init];
        imageConfiguration.secureBaseURL = [images secureBaseURL];
        imageConfiguration.backdropSizes = [images backdropSizes];
        imageConfiguration.logoSizes = [images logoSizes];
        imageConfiguration.posterSizes = [images posterSizes];
        imageConfiguration.profileSizes = [images profileSizes];
        imageConfiguration.stillSizes = [images stillSizes];
        success(imageConfiguration);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        failure();
    }];
}

@end
