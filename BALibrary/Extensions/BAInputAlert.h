//
//  BAInputAlert.h
//  MultipleVideoPlaylists
//
//  Created by Salvador Guerrero on 9/17/12.
//
//

@interface BAInputAlert : NSObject <UIAlertViewDelegate, UITextFieldDelegate>

+ (void)showInputAlertWithTitle:(NSString *)title
                        message:(NSString *)message
                    defaultText:(NSString *)defaultText
                    placeholder:(NSString *)placeholder
               otherButtonTitle:(NSString *)otherButtonTitle
                      onDismiss:(void(^)(NSString *text, NSInteger buttonIndex))block;

@end
