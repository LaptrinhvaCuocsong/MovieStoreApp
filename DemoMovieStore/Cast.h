//
//  Cast.h
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/21/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cast : NSObject

@property (nonatomic) NSUInteger identifier;

@property (nonatomic) NSString * name;

@property (nonatomic) NSString * profilePath;

- (instancetype) initWithIdentifier: (NSUInteger)identifier name: (NSString *)name profilePath: (NSString *)profilePath;

@end
