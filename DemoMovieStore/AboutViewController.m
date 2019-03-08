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
    self.wkWebView = [[WKWebView alloc] init];
    [self.webView addSubview: self.wkWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect frameOfWebView = self.webView.frame;
    frameOfWebView.origin.y = 0;
    self.wkWebView.frame = frameOfWebView;
    NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString: urlString]];
    [self.wkWebView loadRequest: request];
}

@end
