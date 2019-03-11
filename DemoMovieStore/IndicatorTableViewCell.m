#import "IndicatorTableViewCell.h"

@interface IndicatorTableViewCell()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorActivity;

@end

@implementation IndicatorTableViewCell

- (void) startIndicatorActivity {
    [self.indicatorActivity startAnimating];
}

@end
