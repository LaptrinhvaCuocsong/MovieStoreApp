//
//  CustomCollectionViewLayout.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/20/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

#import "CustomCollectionViewLayout.h"

@interface CustomCollectionViewLayout()

@property (nonatomic) CGSize sizeOfCell;

@property (nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> * attributes;

@property (nonatomic) float heightOfContentView;

@end

@implementation CustomCollectionViewLayout

- (NSInteger) getNumberOfCollumn {
    return 2;
}

- (float) getGrap {
    return 10.0;
}

- (void) prepareLayout {
    self.attributes = [[NSMutableArray alloc] init];
    self.heightOfContentView = 0.0;
    float grap = [self getGrap];
    NSInteger numberOfCollumn = [self getNumberOfCollumn];
    float widthOfCollectionView = CGRectGetWidth(self.collectionView.frame);
    float widthOfColumn = (widthOfCollectionView - (numberOfCollumn + 1)*grap) / numberOfCollumn;
    self.sizeOfCell = CGSizeMake(widthOfColumn, widthOfColumn);
    float xOffsets[numberOfCollumn];
    for(NSInteger i = 0; i < numberOfCollumn; i++) {
        xOffsets[i] = (i + 1)*grap + i*widthOfColumn;
    }
    float yOffset = 10.0;
    NSInteger numberOfSection = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    for(NSInteger i = 0; i < numberOfSection; i++) {
        NSInteger numberOfItemInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        for(NSInteger j = 0; j < numberOfItemInSection; j ++) {
            UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem:j inSection:i]];
            NSInteger a = j % numberOfCollumn;
            float x = xOffsets[a];
            attribute.frame = CGRectMake(x, yOffset, self.sizeOfCell.width, self.sizeOfCell.height);
            if(a == numberOfCollumn - 1) {
                yOffset += CGRectGetHeight(attribute.frame) + grap;
            }
            [self.attributes addObject: attribute];
        }
        yOffset += 20.0;
    }
    self.heightOfContentView = yOffset;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.item < self.attributes.count) {
        return [self.attributes objectAtIndex: indexPath.item];
    }
    return nil;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.heightOfContentView);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return CGRectIntersectsRect([evaluatedObject frame], rect);
    }];
    return [self.attributes filteredArrayUsingPredicate: predicate];
}

@end
