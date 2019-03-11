#import "CustomCollectionViewLayout.h"
#import "UICollectionView+Extent.h"

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
        if(i == 0) {
            NSInteger numberOfItemInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
            for(NSInteger j = 0; j < numberOfItemInSection; j ++) {
                UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem:j inSection:i]];
                NSInteger a = j % numberOfCollumn;
                float x = xOffsets[a];
                attribute.frame = CGRectMake(x, yOffset, self.sizeOfCell.width, self.sizeOfCell.height);
                
                if(a == numberOfCollumn - 1 || j == numberOfItemInSection - 1) {
                    yOffset += CGRectGetHeight(attribute.frame) + grap;
                }
                
                [self.attributes addObject: attribute];
            }
        }
        else {
            UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem:0 inSection:i]];
            attribute.frame = CGRectMake(grap, yOffset, CGRectGetWidth(self.collectionView.frame) - 2*grap, 100.0);
            yOffset += 100.0;
            [self.attributes addObject: attribute];
        }
    }
    self.heightOfContentView = yOffset;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.heightOfContentView);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return [self.attributes objectAtIndex: indexPath.item];
    }
    else {
        return [self.attributes lastObject];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return CGRectIntersectsRect([evaluatedObject frame], rect);
    }];
    NSMutableArray * array = [NSMutableArray arrayWithArray: [self.attributes filteredArrayUsingPredicate: predicate]];
    if(!self.collectionView.loadingData) {
        [array removeObject: [self.attributes lastObject]];
    }
    return [NSArray arrayWithArray: array];
}

@end
