//
//  ROSAddControlViewController.h
//  ROSGUIController
//
//  Created by Noah Dayan on 8/22/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ROSButton.h"

@interface ROSAddControlViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleControlField;
@property (weak, nonatomic) IBOutlet UITextField *opControlField;
@property (weak, nonatomic) IBOutlet UITextField *topicControlField;
@property (weak, nonatomic) IBOutlet UITextField *keyControlField;
@property (weak, nonatomic) IBOutlet UITextField *valueControlField;
@property (weak, nonatomic) IBOutlet UIButton *addFieldButton;
- (IBAction)addFieldAction:(id)sender;

@property (strong, nonatomic) ROSButton *addedButton;

@end
