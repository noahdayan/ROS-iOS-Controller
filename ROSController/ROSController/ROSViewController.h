//
//  ROSViewController.h
//  ROSController
//
//  Created by Noah Dayan on 7/21/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SRWebSocket.h"

@interface ROSViewController : UIViewController <SRWebSocketDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectAction:(id)sender;
@property (copy, nonatomic) NSString *websocketAddress;

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
- (IBAction)upAction:(id)sender;
- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;
- (IBAction)downAction:(id)sender;

@end
