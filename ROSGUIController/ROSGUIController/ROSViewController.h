//
//  ROSViewController.h
//  ROSGUIController
//
//  Created by Noah Dayan on 8/17/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SRWebSocket.h"

#import "ROSAddControlViewController.h"

#import "ROSButton.h"

@interface ROSViewController : UIViewController <SRWebSocketDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectAction:(id)sender;
@property (copy, nonatomic) NSString *websocketAddress;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)editAction:(id)sender;

- (void)buttonAction:(UIButton *)sender;
- (void)dragAction:(UIButton *)sender withEvent:(UIEvent *)event;
- (void)doubleTapAction:(UIButton *)sender withEvent:(UIEvent *)event;

@end
