//
//  BAInputAlert.m
//  MultipleVideoPlaylists
//
//  Created by Salvador Guerrero on 9/17/12.
//
//

#import "BAInputAlert.h"

@implementation BAInputAlert
{
    void(^_block)(NSString* text, NSInteger buttonIndex);
    UIAlertView *_alertView;
}

+ (void)showInputAlertWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString *)defaultText placeholder:(NSString *)placeholder otherButtonTitle:(NSString *)otherButtonTitle onDismiss:(void(^)(NSString *text, NSInteger buttonIndex))block
{
    BAInputAlert *inputAlert = [BAInputAlert new];
    
    inputAlert->_alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:inputAlert cancelButtonTitle:@"Cancel" otherButtonTitles:otherButtonTitle, nil];
    inputAlert->_alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField * alertTextField = [inputAlert->_alertView textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.clearButtonMode = UITextFieldViewModeAlways;
    alertTextField.placeholder = placeholder;
    alertTextField.delegate = inputAlert;
    alertTextField.text = defaultText;
    
    inputAlert->_block = [block retain];
    
    [inputAlert->_alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *textFromTextField = [alertView textFieldAtIndex:0].text;
    _block(textFromTextField, buttonIndex);

    [self autorelease];
}


#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _block(textField.text, _alertView.firstOtherButtonIndex);
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];

    [self autorelease];

    return YES;
}

- (void)dealloc
{
    [_block release];
    [_alertView release];

    [super dealloc];
}

@end
