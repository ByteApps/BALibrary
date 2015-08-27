//
//  BAInputAlert.m
//  MultipleVideoPlaylists
//
//  Created by Salvador Guerrero on 9/17/12.
//
//

#import "BAInputAlert.h"

@interface BAInputAlert ()
@property (nonatomic, copy) void(^completionBlock)(NSString* text, NSInteger buttonIndex);
@end

@implementation BAInputAlert

+ (void)showInputAlertWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString *)defaultText placeholder:(NSString *)placeholder otherButtonTitle:(NSString *)otherButtonTitle onDismiss:(void(^)(NSString *text, NSInteger buttonIndex))block
{
    BAInputAlert *inputAlert = [[[self alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:otherButtonTitle, nil] autorelease];
    inputAlert.delegate = inputAlert;
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField * textField = [inputAlert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.placeholder = placeholder;
    textField.delegate = inputAlert;
    textField.text = defaultText;

    //use Block_copy, Reference http://stackoverflow.com/questions/2659072/copying-blocks-ie-copying-them-to-instance-variables-in-objective-c

    inputAlert.completionBlock = block;
    
    [inputAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *textFromTextField = [alertView textFieldAtIndex:0].text;
    self.completionBlock(textFromTextField, buttonIndex);
}


#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.completionBlock(textField.text, self.firstOtherButtonIndex);
    [self dismissWithClickedButtonIndex:0 animated:YES];

    return YES;
}

- (void)dealloc
{
    self.completionBlock = nil;

    [super dealloc];
}

@end
