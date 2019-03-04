//
//  TabItemViewController.m
//  DemoMovieStore
//
//  Created by RTC-HN149 on 2/18/19.
//  Copyright © 2019 RTC-HN149. All rights reserved.
//

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
        [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        //self.revealViewController.rearViewRevealWidth = CGRectGetWidth(self.view.frame);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

@end
