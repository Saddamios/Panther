//
//  LoginViewController.m
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "Utility.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *customerTextField;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Panther";

    [self configureInitialUI];

    [Utility showLoader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Helper Methods

- (void)configureInitialUI {

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific

    [self prepareTextFiledToApper:self.customerTextField];
    [self prepareTextFiledToApper:self.userTextField];
    [self prepareTextFiledToApper:self.passwordTextField];

    self.customerTextField.placeholder  = kCustomerTextString;
    self.userTextField.placeholder  = kUserTextString;
    self.passwordTextField.placeholder  = kPasswordTextString;

    self.passwordTextField.secureTextEntry = YES;

    self.loginButton.layer.cornerRadius = 15.0;
    self.loginButton.layer.borderWidth = 2.0;
    self.loginButton.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)prepareTextFiledToApper:(UITextField *)textField {

    textField.layer.cornerRadius = 15.0;
    textField.layer.borderWidth = 2.0;
    textField.layer.borderColor = [UIColor blackColor].CGColor;

    textField.textAlignment = NSTextAlignmentCenter;

}


- (void)showAlertControllerWithMessage:(NSString *)message {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!!"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Action Methods

- (IBAction)loginButtonAction:(id)sender {

    if([Utility isNullOrEmptyString:self.customerTextField.text]) {

        [self showAlertControllerWithMessage:@"Please enter customer"];
    }
    else if ([Utility isNullOrEmptyString:self.userTextField.text]) {

        [self showAlertControllerWithMessage:@"Please enter user name"];
    }
    else if ([Utility isNullOrEmptyString:self.passwordTextField.text]) {

        [self showAlertControllerWithMessage:@"Please enter password"];

    }
    else {

    }
}

@end
