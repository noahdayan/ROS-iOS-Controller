//
//  ROSAddControlViewController.m
//  ROSGUIController
//
//  Created by Noah Dayan on 8/22/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import "ROSAddControlViewController.h"

@interface ROSAddControlViewController ()

@end

@implementation ROSAddControlViewController
{
    NSMutableArray *textFields;
    NSInteger addCount;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    addCount = 1;
    textFields = [[NSMutableArray alloc] init];
    [textFields addObject:self.keyControlField];
    [textFields addObject:self.valueControlField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    if(theTextField == self.titleControlField || theTextField == self.opControlField || theTextField == self.topicControlField)
    {
        [theTextField resignFirstResponder];
    }
    
    for(UITextField *textField in textFields)
    {
        if(theTextField == textField)
        {
            [theTextField resignFirstResponder];
            break;
        }
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)theTextField
{
    for(UITextField *textField in textFields)
    {
        if(theTextField == textField)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3f];
            
            self.view.frame = CGRectOffset(self.view.frame, 0.0, -195.0);
            
            [UIView commitAnimations];
            break;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    for(UITextField *textField in textFields)
    {
        if(theTextField == textField)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3f];
            
            self.view.frame = CGRectOffset(self.view.frame, 0.0, 195.0);
            
            [UIView commitAnimations];
            break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        if ([self.titleControlField.text length])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            for(int i = 0; i < textFields.count; i += 2)
            {
                UITextField *keyField = [textFields objectAtIndex:i];
                UITextField *valueField = [textFields objectAtIndex:i+1];
                
                NSNumber *number = [formatter numberFromString:valueField.text];
                
                if(number)
                {
                    [dict setObject:number forKey:keyField.text];
                }
                else
                {
                    [dict setObject:valueField.text forKey:keyField.text];
                }
            }
            
            ROSButton *button = [[ROSButton alloc] initWithTitle:self.titleControlField.text Op:self.opControlField.text Topic:self.topicControlField.text Msg:dict];
            self.addedButton = button;
        }
    }
}

- (IBAction)addFieldAction:(id)sender
{
    if(addCount <= 5)
    {
        UITextField *keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 200.0 + (addCount * 40.0), 130.0, 30.0)];
        UITextField *valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(170.0, 200.0 + (addCount * 40.0), 130.0, 30.0)];
    
        [textFields addObject:keyTextField];
        [textFields addObject:valueTextField];
    
        [keyTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [valueTextField setBorderStyle:UITextBorderStyleRoundedRect];
        
        [keyTextField setFont:[UIFont systemFontOfSize:14.0]];
        [valueTextField setFont:[UIFont systemFontOfSize:14.0]];
        
        keyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [keyTextField setReturnKeyType:UIReturnKeyDone];
        [valueTextField setReturnKeyType:UIReturnKeyDone];
        
        [keyTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [valueTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        keyTextField.delegate = self;
        valueTextField.delegate = self;
        
        [self.view addSubview:keyTextField];
        [self.view addSubview:valueTextField];
    
        CGRect frame = self.addFieldButton.frame;
        frame.origin.y += 40.0;
        self.addFieldButton.frame = frame;
    
        if(addCount == 5)
        {
            [self.addFieldButton setHidden:YES];
        }
        
        addCount++;
    }
}
@end
