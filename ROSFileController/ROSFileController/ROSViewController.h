//
//  ROSViewController.h
//  ROSFileController
//
//  Created by Noah Dayan on 8/17/13.
//  Copyright (c) 2013 Noah Dayan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SRWebSocket.h"

#import "ROSParser.h"

#import "ROSButton.h"

@interface ROSViewController : UIViewController <SRWebSocketDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectAction:(id)sender;
@property (copy, nonatomic) NSString *websocketAddress;

@property (weak, nonatomic) IBOutlet UITextField *filePath;
@property (weak, nonatomic) IBOutlet UIButton *parseButton;
- (IBAction)parseAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollArea;

- (void)buttonAction:(UIButton *)sender;

@end
