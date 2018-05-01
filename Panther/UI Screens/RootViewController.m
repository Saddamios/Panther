//
//  ViewController.m
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self configureInitialUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Helper Methods

- (void)configureInitialUI {

    self.loginButton.layer.borderWidth = 2.0;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.cornerRadius = 5.0;

}

- (void)checkAndLaunchLoginController {

    LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.navigationBar.translucent = NO;

    [self presentViewController:navigationController animated:YES completion:nil];


}
#pragma mark - Action Methods

- (IBAction)loginButtonAction:(id)sender {

    [self checkAndLaunchLoginController];
}

@end
