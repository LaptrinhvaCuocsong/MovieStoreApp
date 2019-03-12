#import "TabItemViewController.h"
#import "SWRevealViewController.h"

@interface TabItemViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSlideBar;

@end

@implementation TabItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.revealViewController) {
        [self.btnSlideBar setTarget: self.revealViewController];
        [self.btnSlideBar setAction: @selector(revealToggle:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.clipsToBounds = YES;

    if(self.revealViewController) {
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer: self.revealViewController.tapGestureRecognizer];
    }
}

@end
