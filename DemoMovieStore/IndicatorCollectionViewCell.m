#import "IndicatorCollectionViewCell.h"

@interface IndicatorCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;

@end

@implementation IndicatorCollectionViewCell

- (void) startIndicatorActivity {
    [self.indicatorActivity startAnimating];
}

@end
