//
//  BATextField.m
//  BALibrary
//
//  Created by Salvador Guerrero on 2/20/15.
//  Copyright (c) 2015 ByteApps. All rights reserved.
//

#import "BATextField.h"

@implementation BATextField
{
    id<UITextFieldDelegate> _externalDelegate;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self internalInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self internalInit];
    }

    return self;
}

- (void)internalInit
{
    super.delegate = self;
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    _externalDelegate = delegate;
}

- (void)setMask:(NSString *)mask
{
    if (!mask)
    {
        [_mask release], mask = nil;
    }

    _mask = [mask copy];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([_externalDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)])
    {
        return [_externalDelegate textFieldShouldBeginEditing:textField];
    }

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_externalDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)])
    {
        [_externalDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([_externalDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)])
    {
        return [_externalDelegate textFieldShouldEndEditing:textField];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_externalDelegate respondsToSelector:@selector(textFieldDidEndEditing:)])
    {
        [_externalDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([_externalDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        if (![_externalDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string])
        {
            return NO;
        }
    }

    if (!_mask)
    {
        //we're done here.

        return YES;
    }

    NSInteger newStringIndex = 0;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSMutableString *newMutableString = [NSMutableString string];

    if (!newString.length)
    {
        textField.text = @"";

        return NO;
    }

    if (range.length == 1)
    {
        //the user just deleted text, just allow it.

        return YES;
    }

    for (int i = 0; i < _mask.length && newStringIndex < newString.length; i++)
    {
        unichar charMask = [_mask characterAtIndex:i];
        unichar charNewString = 0;

        if (i < newString.length)
        {
            charNewString = [newString characterAtIndex:i];
        }

        if (charMask == 'X' || charMask == 'x')
        {
            //add the character on the new string
            
            [newMutableString appendFormat:@"%C", [newString characterAtIndex:newStringIndex++]];
        }
        else if (!charNewString || charNewString != charMask)
        {
            //add the mask character

            [newMutableString appendFormat:@"%C", charMask];
        }
        else if (charNewString == charMask)
        {
            //lastly if the char is the same just put it again.

            [newMutableString appendFormat:@"%C", [newString characterAtIndex:newStringIndex++]];
        }
    }

    textField.text = newMutableString;

    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([_externalDelegate respondsToSelector:@selector(textFieldShouldClear:)])
    {
        return [_externalDelegate textFieldShouldClear:textField];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_externalDelegate respondsToSelector:@selector(textFieldShouldReturn:)])
    {
        return [_externalDelegate textFieldShouldReturn:textField];
    }

    return YES;
}

- (void)deleteBackward
{
    [super deleteBackward];

    if ([_externalDelegate respondsToSelector:@selector(textFieldDidDelete:)])
    {
        [(id<BATextFieldDelegate>)_externalDelegate textFieldDidDelete:self];
    }
}

- (BOOL)keyboardInputShouldDelete:(UITextField *)textField
{
    /*
     * Since iOS 8 doesn't call the deleteBackward method because of a bug I found this hack in http://stackoverflow.com/a/26474627/877225
     */

    BOOL shouldDelete = YES;

    if ([UITextField instancesRespondToSelector:_cmd])
    {
        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];

        if (keyboardInputShouldDelete)
        {
            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }


    if (![textField.text length] && UIDevice.currentDevice.systemVersion.intValue >= 8)
    {
        [self deleteBackward];
    }
    
    return shouldDelete;
}

- (void)dealloc
{
    self.mask = nil;

    [super dealloc];
}

@end
