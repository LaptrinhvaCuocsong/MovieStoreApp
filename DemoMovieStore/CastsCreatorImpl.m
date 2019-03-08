#import "CastsCreatorImpl.h"
#import <AFNetworking.h>
#import "Cast.h"
#import "MyNetworking.h"
#import "NSDictionary+Cast.h"

@implementation CastsCreatorImpl

static NSString * const API_GET_CAST_LIST = @"https://api.themoviedb.org/3/movie/%lu/credits?api_key=e7631ffcb8e766993e5ec0c1f4245f93";

- (void) createCastWithMovieId:(NSUInteger)movieId success:(void (^)(NSMutableArray<Cast *> * _Nonnull))success failure:(void (^)(void))failure {
    NSMutableArray * casts = [[NSMutableArray alloc] init];
    NSString * urlString = [NSString stringWithFormat: API_GET_CAST_LIST, movieId];
    AFHTTPSessionManager * manager = [[MyNetworking getInstance] afHttpSessionManager: nil];
    NSURLSessionDataTask * dataTask = [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary * dictionary = (NSMutableDictionary *)responseObject;
        NSMutableArray * array = dictionary[@"cast"];
        for(NSMutableDictionary * item in array) {
            NSUInteger identifier = [item identifier];
            NSString * name = [item name];
            NSString * profilePath = [item profilePath];
            Cast * cast = [[Cast alloc] initWithIdentifier:identifier name:name profilePath:profilePath];
            [casts addObject: cast];
        }
        success(casts);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];
    [dataTask resume];
}

@end
