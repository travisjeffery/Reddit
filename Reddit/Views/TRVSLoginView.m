//
//  TRVSLoginView.m
//  Reddit
//
//  Created by Travis Jeffery on 2/14/14.
//  Copyright (c) 2014 Travis Jeffery. All rights reserved.
//

// views
#import "TRVSLoginView.h"

// models
#import "TRVSUser.h"

@implementation TRVSLoginView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private

- (void)commonInit {
    [self setupUsernameTextField];
    [self setupPasswordTextField];
    [self setupLoginButton];
    [self setupConstraints];
}

- (void)setupUsernameTextField {
    self.usernameTextField = [UITextField new];
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameTextField.placeholder = NSLocalizedString(@"username", nil);
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    [self addSubview:self.usernameTextField];
}

- (void)setupPasswordTextField {
    self.passwordTextField = [UITextField new];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.placeholder = NSLocalizedString(@"password", nil);
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.passwordTextField];
}

- (void)setupLoginButton {
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loginButton setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.loginButton];
}

- (void)setupConstraints {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_usernameTextField]-[_passwordTextField]-[_loginButton]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_usernameTextField, _passwordTextField, _loginButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_usernameTextField]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_usernameTextField)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_passwordTextField]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_passwordTextField)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_loginButton]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_loginButton)]];
}

@end
