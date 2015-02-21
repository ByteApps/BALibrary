//
//  BATextField.h
//  BALibrary
//
//  Created by Salvador Guerrero on 2/20/15.
//  Copyright (c) 2015 ByteApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BATextField;

@protocol BATextFieldDelegate <NSObject>

@optional

- (void)textFieldDidDelete:(BATextField *)textFieldDidDelete;

@end

@interface BATextField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign) id<UITextFieldDelegate> delegate;

@property (nonatomic, copy)     NSString *mask; //Example: (XXX) XXX-XXXX
@property (nonatomic, readonly) NSString *unmaskedText;

@end
