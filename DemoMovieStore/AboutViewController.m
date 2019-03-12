#import "AboutViewController.h"
#import <WebKit/WebKit.h>

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIView *webView;

@property (nonatomic) WKWebView * wkWebView;

@end

@implementation AboutViewController

static NSString * const urlString = @"https://www.themoviedb.org/about/our-history";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wkWebView = [[WKWebView alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.webView addSubview: self.wkWebView];
    NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString: urlString]];
    [self.wkWebView loadRequest: request];
}

@end
